import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server_slot_service.dart' as server;
import 'package:flutter/material.dart';

class EnrollPage extends StatefulWidget {
  final Session session;

  EnrollPage({super.key, required this.session}) {
    if (session.token == "" || session.slot == null) navi.logout();
  }

  @override
  State<StatefulWidget> createState() => EnrollPageState();
}

class EnrollPageState extends State<EnrollPage> {
  List<User> _participantPool = [];
  List<User> _participantList = [];

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    _participantPool = await server.slot_participant_pool(widget.session);
    _participantList = await server.slot_participant_list(widget.session);

    setState(() {
      _participantPool.sort();
      _participantList.sort();
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
    return Scaffold(
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
          //SelectionPanel<User>(
      //  available: _participantPool,
      //   chosen: _participantList,
      //     onAdd: _addParticipant,
      //    onRemove: _removeParticipant,
      //    filter: filterUsers,
      //    builder: (User user) => AppUserTile(user: user),
          //  ),
        ],
      ),
    );
  }
}
