import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/structs/SelectionData.dart';
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
