import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';
import 'package:cptclient/material/dropdowns/StatusDropdown.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:cptclient/static/server_location_anon.dart' as api_anon;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventOverviewManagementPage extends StatefulWidget {
  final Session session;

  EventOverviewManagementPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewManagementPageState();
}

class EventOverviewManagementPageState
    extends State<EventOverviewManagementPage> {
  final DateTimeController _ctrlDateBegin =
      DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd =
      DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));
  final DropdownController<Status> _ctrlStatus =
      DropdownController<Status>(items: server.cacheEventStatus);
  final DropdownController<Location> _ctrlLocation =
      DropdownController<Location>(items: []);
  final DropdownController<User> _ctrlOwner =
      DropdownController<User>(items: []);

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
      status: _ctrlStatus.value,
      location: _ctrlLocation.value,
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
        builder: (context) => EventInfoPage(
          session: widget.session,
          event: event,
        ),
      ),
    );

    _update();
  }

  void _acceptEvent(Event event) async {
    if (!await api_admin.event_accept(widget.session, event)) return;
    _update();
  }

  void _denyEvent(Event event) async {
    if (!await api_admin.event_deny(widget.session, event)) return;
    _update();
  }

  void _suspendEvent(Event event) async {
    if (!await api_admin.event_suspend(widget.session, event)) return;
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
          onSubmit: api_admin.event_edit,
          onPasswordChange: api_admin.event_password_edit,
          onDelete: api_admin.event_delete,
        ),
      ),
    );

    _update();
  }

  Future<void> _handleDuplicate(Event event) async {
    Event newEvent = Event.fromEvent(event);
    newEvent.status = Status.DRAFT;
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

    if (newDateBegin
        .isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) {
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
        title: Text("Event Management"),
      ),
      body: AppBody(
        children: <Widget>[
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.eventBegin),
                child:
                    DateTimeEdit(controller: _ctrlDateBegin, showTime: false),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.eventEnd),
                child: DateTimeEdit(controller: _ctrlDateEnd, showTime: false),
              ),
              LocationDropdown(
                controller: _ctrlLocation,
              ),
              StatusDropdown(
                controller: _ctrlStatus,
              ),
              AppInfoRow(
                info: Text("User"),
                child: AppDropdown<User>(
                  controller: _ctrlOwner,
                  builder: (User user) {
                    return Text("${user.firstname} ${user.lastname}");
                  },
                  onChanged: (User? user) =>
                      setState(() => _ctrlOwner.value = user),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() => _ctrlOwner.value = null),
                ),
              ),
              AppInfoRow(
                info: Text("Show Courses"),
                child: Text("all/yes/no"),
              ),
            ],
          ),
          AppListView(
            items: _events,
            itemBuilder: (Event event) {
              return AppEventTile(
                event: event,
                trailing: _buildTrailing(event),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Event event) {
    return [
      if (event.status == Status.PENDING)
        IconButton(
          icon: const Icon(Icons.highlight_remove),
          onPressed: () => _denyEvent(event),
        ),
      if (event.status == Status.PENDING)
        IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () => _acceptEvent(event),
        ),
      if (event.status == Status.OCCURRING || event.status == Status.REJECTED)
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: () => _suspendEvent(event),
        ),
      PopupMenuButton<VoidCallback>(
        onSelected: (fn) => fn(),
        itemBuilder: (context) => [
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
