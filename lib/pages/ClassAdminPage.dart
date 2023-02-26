import 'package:cptclient/material/panels/UserSelectionPanel.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';

import 'package:intl/intl.dart';

import '../static/server.dart' as server;
import '../static/serverClassAdmin.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';
import '../json/user.dart';

class ClassAdminPage extends StatefulWidget {
  final Session session;
  final int courseID;
  final Slot slot;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isModerator = false;
  final bool isAdmin = false;

  ClassAdminPage({Key? key, required this.session, required this.courseID, required this.slot, required this.onUpdate, required this.isDraft}) : super(key: key);

  @override
  ClassAdminPageState createState() => ClassAdminPageState();
}

class ClassAdminPageState extends State<ClassAdminPage> {
  TextEditingController _ctrlSlotKey = TextEditingController();
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();
  TextEditingController _ctrlSlotBegin = TextEditingController();
  TextEditingController _ctrlSlotEnd = TextEditingController();
  DropdownController<Location> _ctrlCourseLocation = DropdownController<Location>(items: server.cacheLocations);

  List<User> _owners = [];
  List<User> _participants = [];

  ClassAdminPageState();

  @override
  void initState() {
    super.initState();
    _applySlot();
    _requestOwnerList();
    _requestParticipantList();
  }

  void _applySlot() {
    _ctrlSlotKey.text = widget.slot.key;
    _ctrlSlotBegin.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.begin);
    _ctrlSlotEnd.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlCourseLocation.value = widget.slot.location;
  }

  void _gatherSlot() {
    widget.slot.key = _ctrlSlotKey.text;
    widget.slot.begin = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotBegin.text, false);
    widget.slot.end = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotEnd.text, false);
    widget.slot.title = _ctrlSlotTitle.text;
    widget.slot.location = _ctrlCourseLocation.value;
  }

  void _handleSubmit() async {
    _gatherSlot();

    bool success = widget.isDraft ? await server.class_create(widget.session, widget.courseID, widget.slot) : await server.class_edit(widget.session, widget.slot);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify slot')));
      return;
    }

    await server.class_edit_password(widget.session, widget.slot, _ctrlSlotPassword.text);
    _ctrlSlotPassword.text = '';

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
    Slot slot = Slot.fromSlot(widget.slot);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ClassAdminPage(
          session: widget.session,
          courseID: widget.courseID,
          slot: slot,
          onUpdate: widget.onUpdate,
          isDraft: true,
        ),
      ),
    );
  }

  void _requestOwnerList() async {
    List<User> owners = await server.class_owner_list(widget.session, widget.slot);
    owners.sort();

    setState(() {
      _owners = owners;
    });
  }

  void _submitOwnerAddition(User user) async {
    await server.class_owner_add(widget.session, widget.slot, user);
    _requestOwnerList();
  }

  void _submitOwnerRemoval(User user) async {
    await server.class_owner_remove(widget.session, widget.slot, user);
    _requestOwnerList();
  }

  void _requestParticipantList() async {
    List<User> participants = await server.class_participant_list(widget.session, widget.slot);
    participants.sort();

    setState(() {
      _participants = participants;
    });
  }

  void _submitParticipantAddition(User user) async {
    await server.class_participant_add(widget.session, widget.slot, user);
    _requestParticipantList();
  }

  void _submitParticipantRemoval(User user) async {
    await server.class_participant_remove(widget.session, widget.slot, user);
    _requestParticipantList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Slot configuration"),
      ),
      body: AppBody(
        children: [
          if (widget.isDraft == false)
            Row(
              children: [
                Expanded(
                  child: AppSlotTile(
                    slot: widget.slot,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _duplicateSlot,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSlot,
                ),
              ],
            ),
          //Text(widget.slot.status!.toString()),
          PanelSwiper(
            panels: [
              if (!widget.isDraft)
                Panel(
                  "Participants",
                  UserSelectionPanel(
                    usersAvailable: server.cacheMembers,
                    usersChosen: _participants,
                    onAdd: _submitParticipantAddition,
                    onRemove: _submitParticipantRemoval,
                  ),
                ),
              if (!widget.isDraft)
                Panel(
                  "Owners",
                  UserSelectionPanel(
                    usersAvailable: server.cacheMembers,
                    usersChosen: _owners,
                    onAdd: _submitOwnerAddition,
                    onRemove: _submitOwnerRemoval,
                  ),
                ),
              if (!widget.isDraft) Panel("Group Invites", Container()),
              if (!widget.isDraft) Panel("Personal Invites", Container()),
              if (!widget.isDraft) Panel("Level Invites", Container()),
              Panel("Edit", _buildEditPanel()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    return Column(
      children: [
        if (!widget.isDraft)
          AppInfoRow(
            info: Text("Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlSlotKey,
            ),
          ),
        if (!widget.isDraft)
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
          info: Text("Title"),
          child: TextField(
            maxLines: 1,
            controller: _ctrlSlotTitle,
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
        AppButton(
          text: "Save",
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
