import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';

import 'material/app/AppBody.dart';
import 'material/app/AppDropdown.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppSlotTile.dart';

import 'package:intl/intl.dart';

import 'static/db.dart' as db;
import 'static/serverClassAdmin.dart' as server;
import 'json/session.dart';
import 'json/slot.dart';
import 'json/location.dart';

class ClassAdminPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isModerator = false;

  ClassAdminPage({Key? key, required this.session, required this.slot, required this.onUpdate, required this.isDraft}) : super(key: key);

  @override
  ClassAdminPageState createState() => ClassAdminPageState();
}

class ClassAdminPageState extends State<ClassAdminPage> {
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotBegin = TextEditingController();
  TextEditingController _ctrlSlotEnd = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();

  DropdownController<Location> _ctrlCourseLocation = DropdownController<Location>(items: db.cacheLocations);

  ClassAdminPageState();

  @override
  void initState() {
    super.initState();
    _applySlot();
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

    bool success = widget.isDraft ? await server.class_create(widget.session, widget.slot) : await server.class_edit(widget.session, widget.slot);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify slot')));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteSlot() async {
    if (!await server.class_delete(widget.session, widget.slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete time slot')));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _duplicateSlot() {
    Slot _slot = Slot.fromSlot(widget.slot);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassAdminPage(session: widget.session, slot: _slot, onUpdate: widget.onUpdate, isDraft: true)));
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
                if (widget.isModerator)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _duplicateSlot,
                  ),
                if (widget.isModerator)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSlot,
                  ),
              ],
            ),
          //Text(widget.slot.status!.toString()),
          PanelSwiper(panels: [
            if (!widget.isDraft) Panel("Group Invites", Container()),
            if (!widget.isDraft) Panel("Personal Invites", Container()),
            if (!widget.isDraft) Panel("Level Invites", Container()),
            if (widget.isModerator) Panel("Edit", _buildEditPanel()),
          ]),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    return Column(
      children: [
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
        AppButton(
          text: "Save",
          onPressed: _submitSlot,
        ),
      ],
    );
  }
}
