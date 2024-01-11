import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/static/server_event_owner.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventOwnersPage extends StatefulWidget {
  final Session session;
  final Slot slot;

  EventOwnersPage({
    super.key,
    required this.session,
    required this.slot,
  });

  @override
  EventOwnersPageState createState() => EventOwnersPageState();
}

class EventOwnersPageState extends State<EventOwnersPage> {
  late SelectionData<User> _ownerData;

  EventOwnersPageState();

  @override
  void initState() {
    super.initState();

    _ownerData = SelectionData<User>(
        available: [],
        selected: [],
        onSelect: _addSlotOwner,
        onDeselect: _removeSlotOwner,
        filter: filterUsers
    );

    _update();
  }

  void _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    List<User> owners = await server.event_owner_list(widget.session, widget.slot);
    owners.sort();

    _ownerData.available = users;
    _ownerData.selected = owners;
    _ownerData.notifyListeners();
  }

  void _addSlotOwner(User? user) async {
    if (user == null) return;
    if (!await server.event_owner_add(widget.session, widget.slot, user)) return;
    _update();
  }

  void _removeSlotOwner(User? user) async {
    if (user == null) return;
    if (!await server.event_owner_remove(widget.session, widget.slot, user)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventOwners),
      ),
      body: AppBody(
        children: [
          AppSlotTile(
            slot: widget.slot,
          ),
          SelectionPanel<User>(
            dataModel: _ownerData,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
