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

class SlotOwnerPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final Future<List<User>> Function(Session, Slot) onCallOwnerList;
  final Future<bool> Function(Session, Slot, User) onCallOwnerAdd;
  final Future<bool> Function(Session, Slot, User) onCallOwnerRemove;

  SlotOwnerPage({
    super.key,
    required this.session,
    required this.slot,
    required this.onCallOwnerList,
    required this.onCallOwnerAdd,
    required this.onCallOwnerRemove,
  });

  @override
  SlotOwnerPageState createState() => SlotOwnerPageState();
}

class SlotOwnerPageState extends State<SlotOwnerPage> {
  late SelectionData<User> _ownerData;

  SlotOwnerPageState();

  @override
  void initState() {
    super.initState();

    _ownerData = SelectionData<User>(available: [], selected: [], onSelect: _addOwner, onDeselect: _removeOwner, filter: filterUsers);

    _update();
  }

  void _update() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    List<User> owners = await widget.onCallOwnerList(widget.session, widget.slot);
    owners.sort();

    _ownerData.available = users;
    _ownerData.selected = owners;
  }

  void _addOwner(User user) async {
    if (!await widget.onCallOwnerAdd(widget.session, widget.slot, user)) return;
    _update();
  }

  void _removeOwner(User user) async {
    if (!await widget.onCallOwnerRemove(widget.session, widget.slot, user)) return;
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
