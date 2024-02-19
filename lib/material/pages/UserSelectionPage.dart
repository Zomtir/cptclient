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

class UserSelectionPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final String title;
  final Future<List<User>> Function(Session, Slot) onCallList;
  final Future<bool> Function(Session, Slot, User) onCallAdd;
  final Future<bool> Function(Session, Slot, User) onCallRemove;

  UserSelectionPage({
    super.key,
    required this.session,
    required this.slot,
    required this.title,
    required this.onCallList,
    required this.onCallAdd,
    required this.onCallRemove,
  });

  @override
  UserSelectionPageState createState() => UserSelectionPageState();
}

class UserSelectionPageState extends State<UserSelectionPage> {
  late SelectionData<User> _data;

  UserSelectionPageState();

  @override
  void initState() {
    super.initState();

    _data = SelectionData<User>(available: [], selected: [], onSelect: _add, onDeselect: _remove, filter: filterUsers);

    _update();
  }

  void _update() async {
    List<User> available = await server.user_list(widget.session);
    available.sort();

    List<User> selected = await widget.onCallList(widget.session, widget.slot);
    selected.sort();

    _data.available = available;
    _data.selected = selected;
  }

  void _add(User user) async {
    if (!await widget.onCallAdd(widget.session, widget.slot, user)) return;
    _update();
  }

  void _remove(User user) async {
    if (!await widget.onCallRemove(widget.session, widget.slot, user)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppBody(
        children: [
          AppSlotTile(
            slot: widget.slot,
          ),
          SelectionPanel<User>(
            dataModel: _data,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
