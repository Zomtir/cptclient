import 'package:cptclient/api/admin/event/event.dart' as api_admin;
import 'package:cptclient/api/anon/location.dart' as api_anon;
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
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/EventCreatePage.dart';
import 'package:cptclient/pages/EventDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventOverviewManagementPage extends StatefulWidget {
  final UserSession session;

  EventOverviewManagementPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewManagementPageState();
}

class EventOverviewManagementPageState extends State<EventOverviewManagementPage> {
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: []);
  final DropdownController<Occurrence> _ctrlOccurrence = DropdownController<Occurrence>(items: Occurrence.values);
  final DropdownController<Acceptance> _ctrlAcceptance = DropdownController<Acceptance>(items: Acceptance.values);
  final DropdownController<User> _ctrlOwner = DropdownController<User>(items: []);

  List<Event> _events = [];
  final _filterDaysMax = 366;

  EventOverviewManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestLocations();
    _requestOwners();
    _update();
  }

  Future<void> _update() async {
    List<Event> events = await api_admin.event_list(
      widget.session,
      begin: _ctrlDateBegin.getDate(),
      end: _ctrlDateEnd.getDate(),
      location: _ctrlLocation.value,
      occurrence: _ctrlOccurrence.value,
      acceptance: _ctrlAcceptance.value,
      courseTrue: false,
      ownerID: _ctrlOwner.value?.id,
    );

    setState(() {
      _events = events;
    });
  }

  Future<void> _requestLocations() async {
    List<Location> locations = await api_anon.location_list();
    locations.sort();

    setState(() {
      _ctrlLocation.items = locations;
    });
  }

  Future<void> _requestOwners() async {
    List<User> users = await api_regular.user_list(widget.session);
    users.sort();

    setState(() {
      _ctrlOwner.items = users;
    });
  }

  // ignore: unused_element
  Future<void> _selectEvent(Event event) async {
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

  void _acceptEvent(Event event) async {
    if (await api_admin.event_accept(widget.session, event) is! Success) return;
    _update();
  }

  void _rejectEvent(Event event) async {
    if (await api_admin.event_reject(widget.session, event) is! Success) return;
    _update();
  }

  void _suspendEvent(Event event) async {
    if (await api_admin.event_suspend(widget.session, event) is! Success) return;
    _update();
  }

  Future<void> _withdrawEvent(Event event) async {
    if (await api_admin.event_withdraw(widget.session, event) is! Success) return;
    _update();
  }

  Future<void> _handleSelect(Event event) async {
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

  Future<void> _handleCreate() async {
    Event event = Event.fromVoid();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreatePage(
          session: widget.session,
          event: event,
          onSubmit: (session, event) => api_admin.event_create(session, event, null),
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

  // ignore: unused_element
  _pickDateBegin(DateTime newDateBegin) {
    DateTime newDateEnd = _ctrlDateEnd.getDateTime()!;

    if (newDateEnd.isBefore(newDateBegin)) newDateEnd = newDateBegin;

    if (newDateEnd.isAfter(newDateBegin.add(Duration(days: _filterDaysMax)))) {
      newDateEnd = newDateBegin.add(Duration(days: _filterDaysMax));
    }

    setState(() {
      _ctrlDateBegin.setDateTime(newDateBegin);
      _ctrlDateEnd.setDateTime(newDateEnd);
    });
  }

  // ignore: unused_element
  _pickDateEnd(DateTime newDateEnd) {
    DateTime newDateBegin = _ctrlDateBegin.getDateTime()!;

    if (newDateBegin.isAfter(newDateEnd)) newDateBegin = newDateEnd;

    if (newDateBegin.isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) {
      newDateBegin = newDateEnd.add(Duration(days: -_filterDaysMax));
    }

    setState(() {
      _ctrlDateBegin.setDateTime(newDateBegin);
      _ctrlDateEnd.setDateTime(newDateEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
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
                info: AppLocalizations.of(context)!.eventOwner,
                child: ListTile(
                  title: AppDropdown<User>(
                    controller: _ctrlOwner,
                    builder: (User user) {
                      return Text("${user.firstname} ${user.lastname}");
                    },
                    onChanged: (User? user) => setState(() => _ctrlOwner.value = user),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => setState(() => _ctrlOwner.value = null),
                  ),
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
            itemBuilder: (Event event) {
              return InkWell(
                onTap: () => _handleSelect(event),
                child: AppEventTile(
                  event: event,
                  trailing: _buildTrailing(event),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Event event) {
    return [
      if (event.acceptance == Acceptance.pending)
        IconButton(
          icon: const Icon(Icons.drafts_outlined),
          onPressed: () => _withdrawEvent(event),
        ),
      if (event.acceptance == Acceptance.draft ||
          event.acceptance == Acceptance.accepted ||
          event.acceptance == Acceptance.rejected)
        IconButton(
          icon: const Icon(Icons.hourglass_bottom),
          onPressed: () => _suspendEvent(event),
        ),
      if (event.acceptance == Acceptance.pending ||
          event.acceptance == Acceptance.pending ||
          event.acceptance == Acceptance.accepted)
        IconButton(
          icon: const Icon(Icons.highlight_remove),
          onPressed: () => _rejectEvent(event),
        ),
      if (event.acceptance == Acceptance.pending || event.acceptance == Acceptance.rejected)
        IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () => _acceptEvent(event),
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
