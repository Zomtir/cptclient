import 'package:flutter/material.dart';

import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'static/server.dart' as server;
import 'static/serverEventOwner.dart' as server;
import 'json/session.dart';
import 'json/slot.dart';
import 'json/location.dart';
import 'json/user.dart';

class EventDetailPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isOwner;
  final bool isAdmin;

  EventDetailPage({
    Key? key,
    required this.session,
    required this.slot,
    required this.onUpdate,
    required this.isDraft,
    required this.isOwner,
    required this.isAdmin,
  }) : super(key: key);

  @override
  SlotDetailPageState createState() => SlotDetailPageState();
}

class SlotDetailPageState extends State<EventDetailPage> {
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotBegin = TextEditingController();
  TextEditingController _ctrlSlotEnd = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();

  DropdownController<Location> _ctrlCourseLocation = DropdownController<Location>(items: server.cacheLocations);
  String? _confirmAction;

  DropdownController<User> _ctrlDropdownMember = DropdownController<User>(items: server.cacheMembers);

  SlotDetailPageState();

  @override
  void initState() {
    super.initState();

    _applySlot();
    widget.slot.owners = [];
    _requestSlotOwners();

    _confirmAction = widget.isDraft ? 'event_create' : 'event_edit';
  }

  void _duplicateSlot() {
    Slot _slot = Slot.fromSlot(widget.slot);
    _slot.status = Status.DRAFT;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: _slot,
          onUpdate: widget.onUpdate,
          isDraft: true,
          isOwner: true,
          isAdmin: widget.isAdmin,
        ),
      ),
    );
  }

  void _applySlot() {
    _ctrlSlotPassword.text = "";
    _ctrlSlotBegin.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.begin);
    _ctrlSlotEnd.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlCourseLocation.value = widget.slot.location;
  }

  void _gatherSlot() {
    widget.slot.pwd = _ctrlSlotPassword.text;
    widget.slot.location = _ctrlCourseLocation.value;
    widget.slot.begin = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotBegin.text, false);
    widget.slot.end = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotEnd.text, false);
    widget.slot.title = _ctrlSlotTitle.text;
  }

  void _submitSlot() async {
    _gatherSlot();

    final response = await http.post(
      Uri.http(server.serverURL, _confirmAction!),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Token': widget.session.token,
      },
      body: json.encode(widget.slot),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify slot')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Succeeded to modify slot')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteSlot() async {
    if (!await server.event_delete(widget.session, widget.slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete time')));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _requestSlotOwners() async {
    List<User> owners = await server.event_owner_list(widget.session, widget.slot);

    setState(() {
      widget.slot.owners = owners;
    });
  }

  void _addSlotOwner(User? user) async {
    if (user == null) return;
    if (!await server.event_owner_add(widget.session, widget.slot, user)) return;
    _requestSlotOwners();
  }

  void _removeSlotOwner(User? user) async {
    if (user == null) return;
    if (!await server.event_owner_remove(widget.session, widget.slot, user)) return;
    _requestSlotOwners();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Slot configuration"),
      ),
      body: AppBody(
        children: [
          if (widget.slot.id != 0)
            Row(
              children: [
                Expanded(
                  child: AppSlotTile(
                    onTap: (slot) => {},
                    slot: widget.slot,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _duplicateSlot,
                ),
                if (widget.slot.status == Status.DRAFT)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSlot,
                  ),
              ],
            ),
          //Text(widget.slot.status!.toString()),
          PanelSwiper(panels: [
            Panel("Edit", _buildEditPanel()),
            if (!widget.isDraft) Panel("Owners", _buildOwnerPanel()),
            if (!widget.isDraft) Panel("Participants", Container()),
            if (!widget.isDraft) Panel("Group Invites", Container()),
            if (!widget.isDraft) Panel("Personal Invites", Container()),
            if (!widget.isDraft) Panel("Level Invites", Container()),
          ]),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    return Column(
      children: [
        AppInfoRow(
          info: Text("Title"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlSlotTitle,
          ),
        ),
        AppInfoRow(
          info: Text("Password"),
          child: TextField(
            obscureText: true,
            maxLines: 1,
            controller: _ctrlSlotPassword,
            decoration: InputDecoration(
              hintText: "Reset password (leave empty to keep current)",
            ),
          ),
        ),
        AppInfoRow(
          info: Text("Start Time"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlSlotBegin,
          ),
        ),
        AppInfoRow(
          info: Text("End Time"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlSlotEnd,
          ),
        ),
        AppInfoRow(
          info: Text("Location"),
          child: AppDropdown<Location>(
            hint: Text("Select location"),
            controller: _ctrlCourseLocation,
            builder: (Location location) {
              return Text(location.title);
            },
            onChanged: (Location? location) {
              setState(() {
                _ctrlCourseLocation.value = location;
              });
            },
          ),
        ),
        AppButton(
          text: "Save",
          onPressed: _submitSlot,
        ),
      ],
    );
  }

  Widget _buildOwnerPanel() {
    return Column(
      children: [
        AppInfoRow(
          info: Text("User"),
          child: AppDropdown<User>(
            controller: _ctrlDropdownMember,
            builder: (User user) {
              return Text("${user.firstname} ${user.lastname}");
            },
            onChanged: _addSlotOwner,
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => setState(() => _ctrlDropdownMember.value = null),
          ),
        ),
        AppListView(
          items: widget.slot.owners,
          itemBuilder: (User user) {
            return Row(
              children: [
                Expanded(
                  child: AppUserTile(
                    onTap: (User u) => {},
                    item: user,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSlotOwner(user),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
