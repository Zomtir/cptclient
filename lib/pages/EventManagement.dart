import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';
import 'package:cptclient/material/dropdowns/StatusDropdown.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventManagementPage extends StatefulWidget {
  final Session session;

  EventManagementPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventManagementPageState();
}

class EventManagementPageState extends State<EventManagementPage> {
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));
  final DropdownController<Status> _ctrlStatus = DropdownController<Status>(items: server.cacheSlotStatus);
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: server.cacheLocations);
  final DropdownController<User> _ctrlOwner = DropdownController<User>(items: []);

  List<Slot> _events = [];
  final _filterDaysMax = 366;

  EventManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestOwnerFilter();
    _update();
  }

  Future<void> _update() async {
    List<Slot> events = await api_admin.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateEnd.getDate(), _ctrlStatus.value, _ctrlLocation.value, _ctrlOwner.value);

    setState(() {
      _events = events;
    });
  }

  Future<void> _requestOwnerFilter() async {
    List<User> users = await api_regular.user_list(widget.session);
    users.sort();

    setState(() {
      _ctrlOwner.items = users;
    });
  }

  Future<void> _selectSlot(Slot slot) async {
    /*
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotOwnerPage(
          session: widget.session,
          slot: slot,
        ),
      ),
    );

    _update();
    */
  }

  void _acceptReservation(Slot slot) async {
    if (!await api_admin.event_accept(widget.session, slot)) return;
    _update();
  }

  void _denyReservation(Slot slot) async {
    if (!await api_admin.event_deny(widget.session, slot)) return;
    _update();
  }

  _pickDateBegin(DateTime newDateBegin) {
    DateTime newDateEnd = _ctrlDateEnd.getDateTime()!;

    if (newDateEnd.isBefore(newDateBegin)) newDateEnd = newDateBegin;

    if (newDateEnd.isAfter(newDateBegin.add(Duration(days: _filterDaysMax)))) newDateEnd = newDateBegin.add(Duration(days: _filterDaysMax));

    setState(() {
      _ctrlDateBegin.setDateTime(newDateBegin);
      _ctrlDateEnd.setDateTime(newDateEnd);
    });
  }

  _pickDateEnd(DateTime newDateEnd) {
    DateTime newDateBegin = _ctrlDateBegin.getDateTime()!;

    if (newDateBegin.isAfter(newDateEnd)) newDateBegin = newDateEnd;

    if (newDateBegin.isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) newDateBegin = newDateEnd.add(Duration(days: -_filterDaysMax));

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
                info: Text(AppLocalizations.of(context)!.slotBegin),
                child: DateTimeEdit(controller: _ctrlDateBegin, dateOnly: true),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotEnd),
                child: DateTimeEdit(controller: _ctrlDateEnd, dateOnly: true),
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
                  onChanged: (User? user) => setState(() => _ctrlOwner.value = user),
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
            itemBuilder: (Slot slot) {
              return AppSlotTile(
                slot: slot,
                trailing: _buildTrailing(slot),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Slot slot) {
    switch (slot.status) {
      case Status.PENDING:
        return [
          IconButton(
            icon: const Icon(Icons.highlight_remove),
            onPressed: () => _denyReservation(slot),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () => _acceptReservation(slot),
          ),
        ];
      default:
        return [];
    }
  }
}
