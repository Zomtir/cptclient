import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';

import '../material/panels/SelectionPanel.dart';
import '../material/tiles/AppUserTile.dart';
import '../static/navigation.dart' as navi;
import '../static/serverSlotCasual.dart' as server;
import '../json/session.dart';
import '../json/user.dart';

class EnrollPage extends StatefulWidget {
  final Session session;

  EnrollPage({Key? key, required this.session}) : super(key: key) {
    if (session.token == "" || session.slot == null) navi.logout();
  }

  @override
  State<StatefulWidget> createState() => EnrollPageState();
}

class EnrollPageState extends State<EnrollPage> {
  List<User> candidates = [];
  List<User> participants = [];

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    candidates = await server.slot_candidates(widget.session);
    participants = await server.slot_participants(widget.session);

    setState(() {
      candidates.sort();
      participants.sort();
    });
  }

  void _addParticipant(User user) async {
    if (!await server.slot_participant_add(widget.session, user)) return;

    _update();
  }

  void _removeParticipant(User user) async {
    if (!await server.slot_participant_remove(widget.session, user)) return;

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Slot Participation"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logout(),
          )
        ],
      ),
      body: AppBody(
        children: [
          AppSlotTile(slot: widget.session.slot!),
          SelectionPanel<User>(
            available: candidates,
            chosen: participants,
            onAdd: _addParticipant,
            onRemove: _removeParticipant,
            filter: filterUsers,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
