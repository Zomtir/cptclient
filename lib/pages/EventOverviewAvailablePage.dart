import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:cptclient/static/server_location_anon.dart' as api_anon;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventOverviewAvailablePage extends StatefulWidget {
  final UserSession session;

  EventOverviewAvailablePage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewAvailablePageState();
}

class EventOverviewAvailablePageState extends State<EventOverviewAvailablePage> {
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  final DropdownController<Acceptance> _ctrlAcceptance = DropdownController<Acceptance>(items: Acceptance.values);
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Event> _events = [];

  EventOverviewAvailablePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Location> locations = await api_anon.location_list();

    List<Event> events = await api_regular.event_list(
      widget.session,
      begin: _ctrlDateBegin.getDate(),
      end: _ctrlDateEnd.getDate(),
      location: _ctrlLocation.value,
      occurrence: _ctrlOccurrence.value,
      acceptance: _ctrlAcceptance.value,
      courseTrue: false,
    );

    setState(() {
      _ctrlLocation.items = locations;
      _events = events;
    });
  }

  Future<void> _createEvent() async {
    Event event = Event.fromUser(widget.session.user!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          event: event,
          isDraft: true,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  void _handleSelectevent(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoPage(
          session: widget.session,
          event: event,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventAvailable),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createEvent,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventBegin,
                child: DateTimeEdit(controller: _ctrlDateBegin, showTime: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventEnd,
                child: DateTimeEdit(controller: _ctrlDateEnd, showTime: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventLocation,
                child: AppDropdown<Location>(
                  controller: _ctrlLocation,
                  builder: (Location location) => Text(location.key),
                  onChanged: (Location? location) => setState(() => _ctrlLocation.value = location),
                ),
              ),
              AppDropdown<Occurrence>(
                controller: _ctrlOccurrence,
                builder: (Occurrence occurrence) => Text(occurrence.name),
                onChanged: (Occurrence? occurrence) => setState(() => _ctrlOccurrence.value = occurrence),
              ),
              AppDropdown<Acceptance>(
                controller: _ctrlAcceptance,
                builder: (Acceptance acceptance) => Text(acceptance.name),
                onChanged: (Acceptance? acceptance) => setState(() => _ctrlAcceptance.value = acceptance),
              ),
            ],
          ),
          AppListView(
            items: _events,
            itemBuilder: (Event event) {
              return InkWell(
                onTap: () => _handleSelectevent(event),
                child: AppEventTile(
                  event: event,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
