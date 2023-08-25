import 'package:flutter/material.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/panels/SelectionPanel.dart';

import '../static/server.dart' as server;
import '../static/serverUserMember.dart' as server;
import '../static/serverClassAdmin.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';
import '../json/user.dart';

class ClassAdminPage extends StatefulWidget {
  final Session session;
  final int courseID;
  final Slot slot;
  final bool isDraft;
  final bool isModerator = false;
  final bool isAdmin = false;

  ClassAdminPage({Key? key, required this.session, required this.courseID, required this.slot, required this.isDraft}) : super(key: key);

  @override
  ClassAdminPageState createState() => ClassAdminPageState();
}

class ClassAdminPageState extends State<ClassAdminPage> {
  TextEditingController _ctrlSlotKey = TextEditingController();
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();
  DateTimeController _ctrlSlotBegin = DateTimeController(dateTime: DateTime.now());
  DateTimeController _ctrlSlotEnd = DateTimeController(dateTime: DateTime.now().add(Duration(hours: 1)));
  DropdownController<Location> _ctrlSlotLocation = DropdownController<Location>(items: server.cacheLocations);
  bool _ctrlSlotPublic = false;
  bool _ctrlSlotObscured = true;
  TextEditingController _ctrlSlotNote = TextEditingController();

  List<User> _ownerPool = [];
  List<User> _ownerList = [];
  List<User> _participantPool = [];
  List<User> _participantList = [];

  ClassAdminPageState();

  @override
  void initState() {
    super.initState();
    _applySlot();
    _requestOwnerPool();
    _requestOwnerList();
    _requestParticipantPool();
    _requestParticipantList();
  }

  void _applySlot() {
    _ctrlSlotKey.text = widget.slot.key;
    _ctrlSlotBegin.setDateTime(widget.slot.begin);
    _ctrlSlotEnd.setDateTime(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlSlotLocation.value = widget.slot.location;
    _ctrlSlotPublic = widget.slot.public;
    _ctrlSlotObscured = widget.slot.obscured;
    _ctrlSlotNote.text = widget.slot.note;
  }

  void _gatherSlot() {
    widget.slot.key = _ctrlSlotKey.text;
    widget.slot.begin = _ctrlSlotBegin.getDateTime()!;
    widget.slot.end = _ctrlSlotEnd.getDateTime()!;
    widget.slot.title = _ctrlSlotTitle.text;
    widget.slot.location = _ctrlSlotLocation.value;
    widget.slot.public = _ctrlSlotPublic;
    widget.slot.obscured = _ctrlSlotObscured;
    widget.slot.note = _ctrlSlotNote.text;
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

    Navigator.pop(context);
  }

  void _deleteSlot() async {
    if (!await server.class_delete(widget.session, widget.slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete time slot')));
      return;
    }

    Navigator.pop(context);
  }

  Future<void> _duplicateSlot() async {
    Slot slot = Slot.fromSlot(widget.slot);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassAdminPage(
          session: widget.session,
          courseID: widget.courseID,
          slot: slot,
          isDraft: true,
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _requestOwnerPool() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _ownerPool = users;
    });
  }

  void _requestOwnerList() async {
    List<User> users = await server.class_owner_list(widget.session, widget.slot);
    users.sort();

    setState(() {
      _ownerList = users;
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

  void _requestParticipantPool() async {
    List<User> users = await server.class_participant_pool(widget.session, widget.slot);
    users.sort();

    setState(() {
      _participantPool = users;
    });
  }

  void _requestParticipantList() async {
    List<User> users = await server.class_participant_list(widget.session, widget.slot);
    users.sort();

    setState(() {
      _participantList = users;
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
          PanelSwiper(
            panels: [
              if (!widget.isDraft)
                Panel(
                  "Participants",
                  SelectionPanel<User>(
                    available: _participantPool,
                    chosen: _participantList,
                    onAdd: _submitParticipantAddition,
                    onRemove: _submitParticipantRemoval,
                    filter: filterUsers,
                    builder: (User user) => AppUserTile(user: user),
                  ),
                ),
              if (!widget.isDraft)
                Panel(
                  "Owners",
                  SelectionPanel<User>(
                    available: _ownerPool,
                    chosen: _ownerList,
                    onAdd: _submitOwnerAddition,
                    onRemove: _submitOwnerRemoval,
                    filter: filterUsers,
                    builder: (User user) => AppUserTile(user: user),
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
            controller: _ctrlSlotLocation,
            builder: (Location location) {
              return Text(location.title);
            },
            onChanged: (Location? location) {
              setState(() {
                _ctrlSlotLocation.value = location;
              });
            },
          ),
        ),
        AppInfoRow(
          info: Text("Start Time"),
          child: DateTimeEdit(
            controller: _ctrlSlotBegin,
          ),
        ),
        AppInfoRow(
          info: Text("End Time"),
          child: DateTimeEdit(
            controller: _ctrlSlotEnd,
          ),
        ),
        AppInfoRow(
          info: Text("Public"),
          child: Checkbox(
            value: _ctrlSlotPublic,
            onChanged: (bool? active) => setState(() => _ctrlSlotPublic = active!),
          ),
        ),
        AppInfoRow(
          info: Text("Obscured"),
          child: Checkbox(
            value: _ctrlSlotObscured,
            onChanged: (bool? active) => setState(() => _ctrlSlotObscured = active!),
          ),
        ),
        AppInfoRow(
          info: Text("Notes"),
          child: TextField(
            maxLines: 4,
            controller: _ctrlSlotNote,
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
