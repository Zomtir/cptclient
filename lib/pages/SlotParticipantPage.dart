import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SlotParticipantPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final Future<List<User>> Function(Session, Slot) onCallParticipantList;
  final Future<bool> Function(Session, Slot, User) onCallParticipantAdd;
  final Future<bool> Function(Session, Slot, User) onCallParticipantRemove;

  SlotParticipantPage({
    super.key,
    required this.session,
    required this.slot,
    required this.onCallParticipantList,
    required this.onCallParticipantAdd,
    required this.onCallParticipantRemove,
  });

  @override
  SlotParticipantPageState createState() => SlotParticipantPageState();
}

class SlotParticipantPageState extends State<SlotParticipantPage> {
  late SelectionData<User> _participantData;

  SlotParticipantPageState();

  @override
  void initState() {
    super.initState();

    _participantData = SelectionData<User>(available: [], selected: [], onSelect: _addParticipant, onDeselect: _removeParticipant, filter: filterUsers);

    _update();
  }

  void _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    List<User> participants = await widget.onCallParticipantList(widget.session, widget.slot);
    participants.sort();

    _participantData.available = users;
    _participantData.selected = participants;
    _participantData.notifyListeners();
  }

  void _addParticipant(User user) async {
    if (!await widget.onCallParticipantAdd(widget.session, widget.slot, user)) return;
    _update();
  }

  void _removeParticipant(User user) async {
    if (!await widget.onCallParticipantRemove(widget.session, widget.slot, user)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventParticipants),
      ),
      body: AppBody(
        children: [
          AppSlotTile(
            slot: widget.slot,
          ),
          SelectionPanel<User>(
            dataModel: _participantData,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
