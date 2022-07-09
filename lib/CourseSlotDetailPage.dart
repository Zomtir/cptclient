import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';

import 'material/app/AppBody.dart';
import 'material/app/AppDropdown.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppSlotTile.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;
import 'json/session.dart';
import 'json/slot.dart';
import 'json/location.dart';

class CourseSlotDetailPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final void Function() onUpdate;
  
  CourseSlotDetailPage({Key? key, required this.session, required this.slot, required this.onUpdate}) : super(key: key);

  @override
  CourseSlotDetailPageState createState() => CourseSlotDetailPageState();
}

class CourseSlotDetailPageState extends State<CourseSlotDetailPage> {
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotBegin = TextEditingController();
  TextEditingController _ctrlSlotEnd = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();

  DropdownController<Location> _ctrlCourseLocation = DropdownController<Location>(items: db.cacheLocations);
  String?                      _confirmAction;

  CourseSlotDetailPageState();

  @override
  void initState() {
    super.initState();

    _applySlot();

    _confirmAction = widget.slot.id == 0 ? 'course_slot_create' : 'course_slot_edit';
  }

  void _deleteSlot() async {
    final response = await http.head(
      Uri.http(navi.server, 'course_slot_delete', {'slot_id': widget.slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete time slot')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted time slot')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _duplicateSlot() {
    Slot _slot = Slot.fromSlot(widget.slot);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CourseSlotDetailPage(session: widget.session, slot: _slot, onUpdate: widget.onUpdate)));
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
      Uri.http(navi.server, _confirmAction!),
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

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Slot configuration"),
      ),
      body: AppBody(
        children: [
          if (widget.slot.id != 0) Row(
            children: [
              Expanded(
                child: AppSlotTile(
                  onTap: (slot) => {},
                  slot: widget.slot,
                ),
              ),
              if (widget.session.user!.admin_courses) IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _duplicateSlot,
              ),
              if (widget.session.user!.admin_courses || widget.slot.user_id != 0) IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteSlot,
              ),
            ],
          ),
          //Text(widget.slot.status!.toString()),
          PanelSwiper(
            panels: [
              if (widget.slot.id != 0) Panel("Group Invites", Container()),
              if (widget.slot.id != 0) Panel("Personal Invites", Container()),
              if (widget.slot.id != 0) Panel("Level Invites", Container()),
              if (widget.session.user!.admin_courses) Panel("Edit", _buildEditPanel()),
            ]
          ),
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
            builder: (Location location) {return Text(location.title);},
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
