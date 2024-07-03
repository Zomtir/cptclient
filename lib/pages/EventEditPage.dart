import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/static/server_location_anon.dart' as api_anon;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventEditPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final bool isDraft;
  final Future<bool> Function(UserSession, Event) onSubmit;
  final Future<bool> Function(UserSession, Event, String)? onPasswordChange;
  final Future<bool> Function(UserSession, Event)? onDelete;

  EventEditPage({
    super.key,
    required this.session,
    required this.event,
    required this.isDraft,
    required this.onSubmit,
    this.onPasswordChange,
    this.onDelete,
  });

  @override
  EventEditPageState createState() => EventEditPageState();
}

class EventEditPageState extends State<EventEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();
  final TextEditingController _ctrlTitle = TextEditingController();
  final DateTimeController _ctrlBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlEnd = DateTimeController(dateTime: DateTime.now().add(Duration(hours: 1)));
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  bool _ctrlPublic = false;
  bool _ctrlScrutable = true;
  final TextEditingController _ctrlNote = TextEditingController();

  EventEditPageState();

  @override
  void initState() {
    super.initState();

    _receiveLocations();
    _applyEvent();
  }

  Future<void> _receiveLocations() async {
    List<Location> locations = await api_anon.location_list();
    setState(() => _ctrlLocation.items = locations);
  }

  void _applyEvent() {
    _ctrlKey.text = widget.event.key;
    _ctrlTitle.text = widget.event.title;
    _ctrlBegin.setDateTime(widget.event.begin);
    _ctrlEnd.setDateTime(widget.event.end);
    _ctrlLocation.value = widget.event.location;
    _ctrlOccurrence.value = widget.event.occurrence;
    _ctrlPublic = widget.event.public!;
    _ctrlScrutable = widget.event.scrutable!;
    _ctrlNote.text = widget.event.note!;
  }

  void _gatherEvent() {
    widget.event.key = _ctrlKey.text;
    widget.event.title = _ctrlTitle.text;
    widget.event.begin = _ctrlBegin.getDateTime()!;
    widget.event.end = _ctrlEnd.getDateTime()!;
    widget.event.location = _ctrlLocation.value;
    widget.event.occurrence = _ctrlOccurrence.value;
    widget.event.public = _ctrlPublic;
    widget.event.scrutable = _ctrlScrutable;
    widget.event.note = _ctrlNote.text;
  }

  void _handleSubmit() async {
    _gatherEvent();

    if (widget.event.location == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.labelRequired}: ${AppLocalizations.of(context)!.location}")));
      return;
    }

    if (widget.event.occurrence == null || widget.event.occurrence == Occurrence.empty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.labelRequired}: ${AppLocalizations.of(context)!.eventOccurrence}")));
      return;
    }

    if (!await widget.onSubmit(widget.session, widget.event)) return;

    Navigator.pop(context);
  }

  void _handlePasswordChange() async {
    bool success = await widget.onPasswordChange!(widget.session, widget.event, _ctrlPassword.text);
    if (!success) return;

    _ctrlPassword.text = '';
  }

  void _handleDelete() async {
    if (!await widget.onDelete!(widget.session, widget.event)) return;

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
            AppEventTile(
              event: widget.event,
              trailing: [
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _handleDelete,
                  ),
              ],
            ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventTitle,
            child: TextField(
              maxLines: 1,
              controller: _ctrlTitle,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventBegin,
            child: DateTimeEdit(
              controller: _ctrlBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventEnd,
            child: DateTimeEdit(
              controller: _ctrlEnd,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventLocation,
            child: AppDropdown<Location>(
              controller: _ctrlLocation,
              builder: (Location location) => Text(location.name),
              onChanged: (Location? location) => setState(() => _ctrlLocation.value = location),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventOccurrence,
            child: AppDropdown<Occurrence>(
              controller: _ctrlOccurrence,
              builder: (Occurrence occurrence) => Text(occurrence.localizedName(context)),
              onChanged: (Occurrence? occurrence) => setState(() => _ctrlOccurrence.value = occurrence),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventPublic,
            child: Checkbox(
              value: _ctrlPublic,
              onChanged: (bool? active) => setState(() => _ctrlPublic = active!),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventScrutable,
            child: Checkbox(
              value: _ctrlScrutable,
              onChanged: (bool? active) => setState(() => _ctrlScrutable = active!),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventNote,
            child: TextField(
              maxLines: 4,
              controller: _ctrlNote,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
          if (widget.onPasswordChange != null) Divider(),
          if (widget.onPasswordChange != null)
            AppInfoRow(
              info: AppLocalizations.of(context)!.eventPassword,
              child: TextField(
                obscureText: true,
                maxLines: 1,
                controller: _ctrlPassword,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.eventPasswordChange,
                  suffixIcon: IconButton(
                    onPressed: _handlePasswordChange,
                    icon: Icon(Icons.save),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
