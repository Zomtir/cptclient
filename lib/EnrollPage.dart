import 'package:cptclient/material/panels/UserSelectionPanel.dart';
import 'package:flutter/material.dart';

import 'package:cptclient/material/AppBody.dart';

import 'package:intl/intl.dart';

import 'static/navigation.dart' as navi;
import 'static/serverSlotCasual.dart' as server;
import 'json/session.dart';
import 'json/user.dart';

class EnrollPage extends StatefulWidget {
  final Session session;

  EnrollPage({Key? key, required this.session}) : super(key: key) {
    if (session.token == "" || session.slot == null)
      navi.logout();
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

  void _update() async
  {
    candidates = await server.slot_candidates(widget.session);
    participants = await server.slot_participants(widget.session);

    setState(() {
      candidates.sort();
      participants.sort();
    });
  }

  void _enrolMember(User user) async {
    if (!await server.slot_participant_add(widget.session, user)) return;

    _update();
  }

  void _dimissMember(User user) async {
    if (!await server.slot_participant_remove(widget.session, user)) return;

    _update();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Enroll for this slot"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logout(),
          )
        ],
      ),
      body: AppBody(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("[${widget.session.slot!.id.toString()}] ${widget.session.slot!.title}",
                style: TextStyle(fontWeight: FontWeight.bold),),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule),
              Text("${DateFormat("yyyy-MM-dd HH:mm").format(widget.session.slot!.begin)} - ${DateFormat("yyyy-MM-dd HH:mm").format(widget.session.slot!.end)}"),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.room),
              Text(widget.session.slot!.location!.title),
            ],
          ),
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          UserSelectionPanel(
            usersAvailable: candidates,
            usersChosen: participants,
            onAdd: _enrolMember,
            onRemove: _dimissMember,
          ),
        ],
      ),
    );
  }

}
