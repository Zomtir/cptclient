import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/api/owner/event/imports.dart' as api_owner;
import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/EventCreatePage.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventOverviewOwnershipPage extends StatefulWidget {
  final UserSession session;

  EventOverviewOwnershipPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewOwnershipPageState();
}

class EventOverviewOwnershipPageState extends State<EventOverviewOwnershipPage> {
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  final DropdownController<Acceptance> _ctrlAcceptance = DropdownController<Acceptance>(items: Acceptance.values);

  List<Event> _events = [];

  EventOverviewOwnershipPageState();

  @override
  void initState() {
    super.initState();
    _receiveLocations();
    _update();
  }

  Future<void> _receiveLocations() async {
    List<Location> locations = await api_anon.location_list();

    setState(() {
      _ctrlLocation.items = locations;
    });
  }

  Future<void> _update() async {
    var result = await api_owner.event_list(
        widget.session,
        _ctrlDateBegin.getDate(),
        _ctrlDateEnd.getDate(),
        _ctrlLocation.value,
        _ctrlOccurrence.value,
        _ctrlAcceptance.value
    );
    if (result is! Success) return;

    setState(() {
      _events = result.unwrap();
    });
  }

  Future<void> _handleCreate() async {
    Event event = Event.fromUser(widget.session.user!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreatePage(
          session: widget.session,
          event: event,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  Future<void> _handleDuplicate(Event event) async {
    Event newEvent = Event.fromEvent(event);
    newEvent.acceptance = Acceptance.draft;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreatePage(
          session: widget.session,
          event: newEvent,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  void _handleSelect(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          eventID: event.id,
        ),
      ),
    );

    _update();
  }

  // ignore: unused_element
  void _handleOwners(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwners,
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_owner_list(widget.session, event),
          onCallAdd: (user) => api_owner.event_owner_add(widget.session, event, user),
          onCallRemove: (user) => api_owner.event_owner_remove(widget.session, event, user),
        ),
      ),
    );

    _update();
  }

  // ignore: unused_element
  void _handleAttendance(Event event, String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventAttendancePresences,
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_attendance_presence_list(widget.session, event, role),
          onCallAdd: (user) => api_owner.event_attendance_presence_add(widget.session, event, user, role),
          onCallRemove: (user) => api_owner.event_attendance_presence_remove(widget.session, event, user, role),
        ),
      ),
    );

    _update();
  }

  Future<void> _submitEvent(Event event) async {
    if (await api_owner.event_submit(widget.session, event) is! Success) return;
    _update();
  }

  Future<void> _withdrawEvent(Event event) async {
    if (await api_owner.event_withdraw(widget.session, event) is! Success) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventOwnership),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: [
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventBegin,
                child: DateTimeField(controller: _ctrlDateBegin, showTime: false),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventEnd,
                child: DateTimeField(controller: _ctrlDateEnd, showTime: false),
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
                info: AppLocalizations.of(context)!.eventAcceptance,
                child: AppDropdown<Acceptance>(
                  controller: _ctrlAcceptance,
                  builder: (Acceptance acceptance) => Text(acceptance.localizedName(context)),
                  onChanged: (Acceptance? acceptance) => setState(() => _ctrlAcceptance.value = acceptance),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.course,
                child: Text("all/yes/no"),
              ),
            ],
          ),
          AppListView(
            items: _events,
            itemBuilder: (Event event) => event.buildTile(
              context,
              onTap: () => _handleSelect(event),
              trailing: _buildTrailing(event),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Event event) {
    return [
      if (event.acceptance == Acceptance.draft)
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => _submitEvent(event),
        ),
      if (event.acceptance == Acceptance.pending ||
          event.acceptance == Acceptance.accepted ||
          event.acceptance == Acceptance.rejected)
        IconButton(
          icon: const Icon(Icons.drafts_outlined),
          onPressed: () => _withdrawEvent(event),
        ),
      PopupMenuButton<VoidCallback>(
        onSelected: (fn) => fn(),
        itemBuilder: (context) => [
          PopupMenuItem<VoidCallback>(
            value: () => _handleDuplicate(event),
            child: Text(AppLocalizations.of(context)!.actionDuplicate),
          ),
        ],
      ),
    ];
  }
}
