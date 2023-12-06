import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';

import '../static/serverUserMember.dart' as server;
import '../static/serverEventOwner.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/user.dart';

class EventParticipantsPage extends StatefulWidget {
  final Session session;
  final Slot slot;

  EventParticipantsPage({
    Key? key,
    required this.session,
    required this.slot,
  }) : super(key: key);

  @override
  EventParticipantsPageState createState() => EventParticipantsPageState();
}

class EventParticipantsPageState extends State<EventParticipantsPage> {
  List<User> _users = [];
  List<User> _participants = [];

  EventParticipantsPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    List<User> participants = [];// = await server.event_participant_list(widget.session, widget.slot);
    participants.sort();

    setState(() {
      _users = users;
      _participants = participants;
    });
  }

  void _addParticipant(User? user) async {
    if (user == null) return;
    //if (!await server.event_participant_add(widget.session, widget.slot, user)) return;
    _update();
  }

  void _removeParticipant(User? user) async {
    if (user == null) return;
    //if (!await server.event_participant_remove(widget.session, widget.slot, user)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventParticipants),
      ),
      body: AppBody(
        children: [
            AppSlotTile(
              slot: widget.slot,
            ),
      //SelectionPanel<User>(
      //  available: _users,
      // chosen: _participants,
      //onAdd: _addParticipant,
      //onRemove: _removeParticipant,
      //filter: filterUsers,
      //builder: (User user) => AppUserTile(user: user),
          //),
        ],
      ),
    );
  }
}
