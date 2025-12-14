import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventCreatePage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final Future<Result> Function(UserSession, Event) onSubmit;
  final Future<Result> Function(UserSession, Event, String)? onPasswordChange;

  EventCreatePage({
    super.key,
    required this.session,
    required this.event,
    required this.onSubmit,
    this.onPasswordChange,
  });

  @override
  EventCreatePageState createState() => EventCreatePageState();
}

class EventCreatePageState extends State<EventCreatePage> {
  final TextEditingController _ctrlTitle = TextEditingController();
  final DateTimeController _ctrlBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlEnd = DateTimeController(dateTime: DateTime.now().add(Duration(hours: 1)));
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  bool _ctrlPublic = false;
  bool _ctrlScrutable = true;
  final TextEditingController _ctrlNote = TextEditingController();

  EventCreatePageState();

  @override
  void initState() {
    super.initState();

    _receiveLocations();
    _applyEvent();
  }

  Future<void> _receiveLocations() async {
    Result<List<Location>> result_locations = await api_anon.location_list();
    if (result_locations is! Success) return;
    setState(() => _ctrlLocation.items = result_locations.unwrap());
  }

  void _applyEvent() {
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

    var result = await widget.onSubmit(widget.session, widget.event);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventCreate),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventTitle,
            child: TextField(
              maxLines: 1,
              controller: _ctrlTitle,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventBegin,
            child: DateTimeField(
              controller: _ctrlBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventEnd,
            child: DateTimeField(
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
        ],
      ),
    );
  }
}
