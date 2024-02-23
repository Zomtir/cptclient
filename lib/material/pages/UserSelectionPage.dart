import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';

class UserSelectionPage extends StatefulWidget {
  final Session session;
  final String title;
  final Widget tile;
  final Future<List<User>> Function(Session) onCallAvailable;
  final Future<List<User>> Function(Session) onCallSelected;
  final Future<bool> Function(Session, User) onCallAdd;
  final Future<bool> Function(Session, User) onCallRemove;

  UserSelectionPage({
    super.key,
    required this.session,
    required this.title,
    required this.tile,
    required this.onCallAvailable,
    required this.onCallSelected,
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
    List<User> available = await widget.onCallAvailable(widget.session);
    available.sort();

    List<User> selected = await widget.onCallSelected(widget.session);
    selected.sort();

    _data.available = available;
    _data.selected = selected;
  }

  void _add(User user) async {
    if (!await widget.onCallAdd(widget.session, user)) return;
    _update();
  }

  void _remove(User user) async {
    if (!await widget.onCallRemove(widget.session, user)) return;
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
          widget.tile,
          SelectionPanel<User>(
            dataModel: _data,
            builder: (User user) => AppUserTile(user: user),
          ),
        ],
      ),
    );
  }
}
