import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventCreateBatchPage extends StatefulWidget {
  final UserSession session;
  final Event event;
  final bool isDraft;
  final Future<bool> Function(UserSession, Event) onSubmit;
  final Future<bool> Function(UserSession, Event, String)? onPasswordChange;
  final Future<bool> Function(UserSession, Event)? onDelete;

  EventCreateBatchPage({
    super.key,
    required this.session,
    required this.event,
    required this.isDraft,
    required this.onSubmit,
    this.onPasswordChange,
    this.onDelete,
  });

  @override
  EventCreateBatchPageState createState() => EventCreateBatchPageState();
}

class EventCreateBatchPageState extends State<EventCreateBatchPage> {
  final DateTimeController _ctrlBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlEnd = DateTimeController(dateTime: DateTime.now().add(Duration(hours: 1)));
  final TextEditingController _ctrlTitle = TextEditingController();
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  bool _ctrlPublic = false;
  bool _ctrlScrutable = true;

  final List<bool> _ctrlBatchDays = List<bool>.filled(7, false);
  final DateTimeController _ctrlBatchBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlBatchEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 7)));

  bool _enabled = true;

  EventCreateBatchPageState();

  @override
  void initState() {
    super.initState();

    _receiveLocations();
    _applyEvent();
  }

  Future<void> _receiveLocations() async {
    List<Location> locations = await api_anon.location_list();

    setState(() {
      _ctrlLocation.items = locations;
    });
  }

  void _applyEvent() {
    _ctrlBegin.setDateTime(widget.event.begin);
    _ctrlEnd.setDateTime(widget.event.end);
    _ctrlTitle.text = widget.event.title;
    _ctrlLocation.value = widget.event.location;
    _ctrlOccurrence.value = widget.event.occurrence;
    _ctrlPublic = widget.event.public!;
    _ctrlScrutable = widget.event.scrutable!;
  }

  void _gatherEvent() {
    widget.event.title = _ctrlTitle.text;
    widget.event.begin = _ctrlBegin.getDateTime()!;
    widget.event.end = _ctrlEnd.getDateTime()!;
    widget.event.location = _ctrlLocation.value;
    widget.event.occurrence = _ctrlOccurrence.value;
    widget.event.public = _ctrlPublic;
    widget.event.scrutable = _ctrlScrutable;
  }

  void _handleSubmit() async {
    setState(() => _enabled = false);
    _gatherEvent();

    if (widget.event.location == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.labelRequired}: ${AppLocalizations.of(context)!.location}")));
      setState(() => _enabled = true);
      return;
    }

    if (widget.event.occurrence == null || widget.event.occurrence == Occurrence.empty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.labelRequired}: ${AppLocalizations.of(context)!.eventOccurrence}")));
      setState(() => _enabled = true);
      return;
    }

    List<DateTime> dates = _getFilteredDates();

    if (dates.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Too many dates (${dates.length})')));
      setState(() => _enabled = true);
      return;
    }

    for (DateTime date in dates) {
      Event event = Event.fromEvent(widget.event);
      event.begin = event.begin.applyDate(date);
      event.end = event.end.applyDate(date);

      widget.onSubmit(widget.session, event);
    }

    Navigator.pop(context);
  }

  List<DateTime> _getFilteredDates() {
    List<DateTime> dates = [];
    DateTime startDate = _ctrlBatchBegin.getDate();
    DateTime endDate = _ctrlBatchEnd.getDate();

    if (endDate.isBefore(startDate)) return [];

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      // If the weekday is included, add the date
      if (_ctrlBatchDays[currentDate.weekday - 1]) {
        dates.add(currentDate);
      }

      // Move to the next day
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventEdit),
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
            child: DateTimeEdit(
              controller: _ctrlBegin,
              showDate: false,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventEnd,
            child: DateTimeEdit(
              controller: _ctrlEnd,
              showDate: false,
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
            info: AppLocalizations.of(context)!.dateWeekday,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildDays(context),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.dateFrameBegin,
            child: DateTimeEdit(
              controller: _ctrlBatchBegin,
              showTime: false,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.dateFrameEnd,
            child: DateTimeEdit(
              controller: _ctrlBatchEnd,
              showTime: false,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _enabled ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDays(BuildContext context) {
    List<String> weekdays = getWeekdaysShort(context);
    return List.generate(7, (index) {
      return Column(
        children: [
          Text("${weekdays[index]}"),
          Checkbox(
              value: _ctrlBatchDays[index], onChanged: (bool? value) => setState(() => _ctrlBatchDays[index] = value!))
        ],
      );
    });
  }
}
