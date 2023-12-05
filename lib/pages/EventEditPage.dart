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
import '../static/serverEventMember.dart' as server;
import '../static/serverEventOwner.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';

class EventEditPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final bool isDraft;

  EventEditPage({
    Key? key,
    required this.session,
    required this.slot,
    required this.isDraft,
  }) : super(key: key);

  @override
  EventEditPageState createState() => EventEditPageState();
}

class EventEditPageState extends State<EventEditPage> {
  TextEditingController _ctrlSlotPassword = TextEditingController();
  TextEditingController _ctrlSlotBegin = TextEditingController();
  TextEditingController _ctrlSlotEnd = TextEditingController();
  TextEditingController _ctrlSlotTitle = TextEditingController();
  DropdownController<Location> _ctrlSlotLocation = DropdownController<Location>(items: server.cacheLocations);

  EventEditPageState();

  @override
  void initState() {
    super.initState();

    _applySlot();
  }

  Future<void> _duplicateSlot() async {
    Slot _slot = Slot.fromSlot(widget.slot);
    _slot.status = Status.DRAFT;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          slot: _slot,
          isDraft: true,
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _applySlot() {
    _ctrlSlotBegin.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.begin);
    _ctrlSlotEnd.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlSlotLocation.value = widget.slot.location;
  }

  void _gatherSlot() {
    widget.slot.location = _ctrlSlotLocation.value;
    widget.slot.begin = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotBegin.text, false);
    widget.slot.end = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlSlotEnd.text, false);
    widget.slot.title = _ctrlSlotTitle.text;
  }

  void _handleSubmit() async {
    _gatherSlot();

    bool success = widget.isDraft ? await server.event_create(widget.session, widget.slot) : await server.event_edit(widget.session, widget.slot);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify slot')));
      return;
    }

    await server.event_edit_password(widget.session, widget.slot, _ctrlSlotPassword.text);
    _ctrlSlotPassword.text = '';

    Navigator.pop(context);
  }

  void _deleteSlot() async {
    if (!await server.event_delete(widget.session, widget.slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete time')));
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppSlotTile(
              slot: widget.slot,
              trailing: [
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
          LocationDropdown(controller: _ctrlSlotLocation, onChanged: ()=>{}),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
