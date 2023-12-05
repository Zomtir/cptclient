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

class EventOwnersPage extends StatefulWidget {
  final Session session;
  final Slot slot;

  EventOwnersPage({
    Key? key,
    required this.session,
    required this.slot,
  }) : super(key: key);

  @override
  EventOwnersPageState createState() => EventOwnersPageState();
}

class EventOwnersPageState extends State<EventOwnersPage> {
  List<User> _users = [];
  List<User> _owners = [];

  EventOwnersPageState();

  @override
  void initState() {
    super.initState();

    _update();
  }

  void _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    List<User> owners = await server.event_owner_list(widget.session, widget.slot);
    owners.sort();

    setState(() {
      _users = users;
      _owners = owners;
    });

    print("Debug- Change is triggered");
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
    return new Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventOwners),
      ),
      body: AppBody(
        children: [
          AppSlotTile(
            slot: widget.slot,
          ),
          SelectionPanel<User>(
            available: _users,
            chosen: _owners,
            onAdd: _addSlotOwner,
            onRemove: _removeSlotOwner,
            filter: filterUsers,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
