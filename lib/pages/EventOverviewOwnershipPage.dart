import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/api/owner/event/imports.dart' as api_owner;
import 'package:cptclient/json/acceptance.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/layouts/FilterToggle.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/pages/EventDetailOwnershipPage.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    List<Event> events = await api_owner.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateEnd.getDate(),
        _ctrlLocation.value, _ctrlOccurrence.value, _ctrlAcceptance.value);

    setState(() {
      _events = events;
    });
  }

  Future<void> _handleCreate() async {
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

  Future<void> _handleDuplicate(Event event) async {
    Event newEvent = Event.fromEvent(event);
    newEvent.acceptance = Acceptance.draft;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          event: newEvent,
          isDraft: true,
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
        builder: (context) => EventDetailOwnershipPage(
          session: widget.session,
          eventID: event.id,
        ),
      ),
    );

    _update();
  }

  void _handleEdit(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          event: event,
          isDraft: false,
          onSubmit: api_owner.event_edit,
          onPasswordChange: api_owner.event_password_edit,
          onDelete: api_owner.event_delete,
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
          tile: AppEventTile(event: event),
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
  void _handleParticipants(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantPresences,
          tile: AppEventTile(event: event),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_participant_presence_list(widget.session, event),
          onCallAdd: (user) => api_owner.event_participant_presence_add(widget.session, event, user),
          onCallRemove: (user) => api_owner.event_participant_presence_remove(widget.session, event, user),
        ),
      ),
    );

    _update();
  }

  Future<void> _submitEvent(Event event) async {
    if (!await api_owner.event_submit(widget.session, event)) return;
    _update();
  }

  Future<void> _withdrawEvent(Event event) async {
    if (!await api_owner.event_withdraw(widget.session, event)) return;
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventOwnership),
      ),
      body: AppBody(
        children: [
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
                  builder: (Location location) => Text(location.name),
                  onChanged: (Location? location) => setState(() => _ctrlLocation.value = location),
                ),
              ),
              AppDropdown<Occurrence>(
                controller: _ctrlOccurrence,
                builder: (Occurrence occurrence) => Text(occurrence.localizedName(context)),
                onChanged: (Occurrence? occurrence) => setState(() => _ctrlOccurrence.value = occurrence),
              ),
              AppDropdown<Acceptance>(
                controller: _ctrlAcceptance,
                builder: (Acceptance acceptance) => Text(acceptance.localizedName(context)),
                onChanged: (Acceptance? acceptance) => setState(() => _ctrlAcceptance.value = acceptance),
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
          if (event.acceptance == Acceptance.draft)
            PopupMenuItem<VoidCallback>(
              value: () => _handleEdit(event),
              child: Text(AppLocalizations.of(context)!.actionEdit),
            ),
          PopupMenuItem<VoidCallback>(
            value: () => _handleDuplicate(event),
            child: Text(AppLocalizations.of(context)!.actionDuplicate),
          ),
        ],
      ),
    ];
  }
}
