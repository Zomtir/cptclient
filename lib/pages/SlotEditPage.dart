import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';

import 'package:intl/intl.dart';

import '../static/server.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';

class SlotEditPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final bool isDraft;
  final Future<bool> Function(Session, Slot) onSubmit;
  final Future<bool> Function(Session, Slot, String)? onPasswordChange;
  final Future<bool> Function(Session, Slot)? onDelete;

  SlotEditPage({
    super.key,
    required this.session,
    required this.slot,
    required this.isDraft,
    required this.onSubmit,
    this.onPasswordChange,
    this.onDelete,
  });

  @override
  SlotEditPageState createState() => SlotEditPageState();
}

class SlotEditPageState extends State<SlotEditPage> {
  final TextEditingController _ctrlSlotKey = TextEditingController();
  final TextEditingController _ctrlSlotPassword = TextEditingController();
  final TextEditingController _ctrlSlotBegin = TextEditingController();
  final TextEditingController _ctrlSlotEnd = TextEditingController();
  final TextEditingController _ctrlSlotTitle = TextEditingController();
  final DropdownController<Location> _ctrlSlotLocation = DropdownController<Location>(items: server.cacheLocations);
  bool _ctrlSlotPublic = false;
  bool _ctrlSlotObscured = true;
  final TextEditingController _ctrlSlotNote = TextEditingController();

  SlotEditPageState();

  @override
  void initState() {
    super.initState();

    _applySlot();
  }

  void _applySlot() {
    _ctrlSlotKey.text = widget.slot.key;
    _ctrlSlotBegin.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.begin);
    _ctrlSlotEnd.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlSlotLocation.value = widget.slot.location;
    _ctrlSlotPublic = widget.slot.public;
    _ctrlSlotObscured = widget.slot.obscured;
    _ctrlSlotNote.text = widget.slot.note;
  }

  void _gatherSlot() {
    widget.slot.key = _ctrlSlotKey.text;
    widget.slot.location = _ctrlSlotLocation.value;
    widget.slot.begin = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotBegin.text, false);
    widget.slot.end = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotEnd.text, false);
    widget.slot.title = _ctrlSlotTitle.text;
    widget.slot.public = _ctrlSlotPublic;
    widget.slot.obscured = _ctrlSlotObscured;
    widget.slot.note = _ctrlSlotNote.text;
  }

  void _handleSubmit() async {
    _gatherSlot();
    bool success = await widget.onSubmit(widget.session, widget.slot);
    if (!success) return;

    Navigator.pop(context);
  }

  void _handlePasswordChange() async {
    bool success = await widget.onPasswordChange!(widget.session, widget.slot, _ctrlSlotPassword.text);
    if (!success) return;

    _ctrlSlotPassword.text = '';
  }

  void _deleteSlot() async {
    bool success = await widget.onDelete!(widget.session, widget.slot);

    if (!success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppSlotTile(
              slot: widget.slot,
              trailing: [
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteSlot,
                  ),
              ],
            ),
          AppInfoRow(
            info: Text("Key"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlSlotKey,
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
          LocationDropdown(
            controller: _ctrlSlotLocation,
            onChanged: () => setState(() => {/* Location has changed */}),
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
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
          if (widget.onPasswordChange != null) Divider(),
          if (widget.onPasswordChange != null)
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
              trailing: IconButton(icon: Icon(Icons.save), onPressed: _handlePasswordChange),
            ),
        ],
      ),
    );
  }
}
