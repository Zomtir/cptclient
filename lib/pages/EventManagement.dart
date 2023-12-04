import 'package:flutter/material.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/PanelSwiper.dart';

import '../material/DateTimeEdit.dart';
import '../material/FilterToggle.dart';
import 'EventDetailPage.dart';

import '../static/server.dart' as server;
import '../static/serverUserMember.dart' as server;
import '../static/serverEventAdmin.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';
import '../json/user.dart';

class EventManagementPage extends StatefulWidget {
  final Session session;

  EventManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventManagementPageState();
}

class EventManagementPageState extends State<EventManagementPage> {
  DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -1)));
  DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Slot> _events = [];
  List<Slot> _eventsFiltered = [];
  final _filterDaysMax = 366;

  int _panelIndex = 0;
  List<String> _panelStatus = ['PENDING', 'OCCURRING', 'REJECTED', 'CANCELED'];

  DropdownController<User> _ctrlDropdownOwner = DropdownController<User>(items: []);
  DropdownController<Location> _ctrlDropdownLocation = DropdownController<Location>(items: server.cacheLocations);

  EventManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestOwnerFilter();
    _requestSlots();
  }

  Future<void> _requestOwnerFilter() async {
    List<User> users = await server.user_list(widget.session);
    users.sort();

    setState(() {
      _ctrlDropdownOwner.items = users;
    });
  }

  Future<void> _requestSlots() async {
    _events = await server.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateBegin.getDate(), _panelStatus[_panelIndex], _ctrlDropdownOwner.value);
    _filterReservations();
  }

  void _filterReservations() {
    setState(() {
      _eventsFiltered = _events.where((reservation) {
        bool locationFilter = (_ctrlDropdownLocation.value == null) ? true : (reservation.location == _ctrlDropdownLocation.value);
        bool courseFilter = true; // TODO actually implement this (Any, onlyCourse, onlyEvent)
        return locationFilter && courseFilter;
      }).toList();
    });
  }

  Future<void> _selectSlot(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          isDraft: false,
          isOwner: false,
          isAdmin: true,
        ),
      ),
    );

    _requestSlots();
  }

  void _acceptReservation(Slot slot) async {
    if (!await server.event_accept(widget.session, slot)) return;
    _requestSlots();
  }

  void _denyReservation(Slot slot) async {
    if (!await server.event_deny(widget.session, slot)) return;
    _requestSlots();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Event Management"),
      ),
      body: AppBody(
        children: <Widget>[
          AppInfoRow(
            info: Text("Begin Date"),
            child: DateTimeEdit(controller: _ctrlDateBegin, onUpdate: _pickDateBegin, dateOnly: true),
          ),
          AppInfoRow(
            info: Text("End Date"),
            child: DateTimeEdit(controller: _ctrlDateEnd, onUpdate: _pickDateEnd, dateOnly: true),
          ),
          AppInfoRow(
            info: Text("User"),
            child: AppDropdown<User>(
              controller: _ctrlDropdownOwner,
              builder: (User user) {
                return Text("${user.firstname} ${user.lastname}");
              },
              onChanged: _pickMember,
            ),
            trailing: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _pickMember(null),
            ),
          ),
          PanelSwiper(
            swipes: 0,
            onChange: (int index) {
              _panelIndex = index;
              _requestSlots();
            },
            panels: [
              Panel("Pending", _buildSlotPendingPanel()),
              Panel("Occurring", _buildSlotPendingPanel()),
              Panel("Rejected", _buildSlotPendingPanel()),
              Panel("Canceled", _buildSlotPendingPanel()),
            ],
          ),
        ],
      ),
    );
  }

  Future _pickDateBegin(DateTime newDateBegin) async {
    DateTime newDateEnd = _ctrlDateEnd.getDateTime()!;

    if (newDateEnd.isBefore(newDateBegin)) newDateEnd = newDateBegin;

    if (newDateEnd.isAfter(newDateBegin.add(Duration(days: _filterDaysMax)))) newDateEnd = newDateBegin.add(Duration(days: _filterDaysMax));

    setState(() {
      _ctrlDateBegin.setDateTime(newDateBegin);
      _ctrlDateEnd.setDateTime(newDateEnd);
    });
    _requestSlots();
  }

  Future _pickDateEnd(DateTime newDateEnd) async {
    DateTime newDateBegin = _ctrlDateBegin.getDateTime()!;

    if (newDateBegin.isAfter(newDateEnd)) newDateBegin = newDateEnd;

    if (newDateBegin.isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) newDateBegin = newDateEnd.add(Duration(days: -_filterDaysMax));

    setState(() {
      _ctrlDateBegin.setDateTime(newDateBegin);
      _ctrlDateEnd.setDateTime(newDateEnd);
    });
    _requestSlots();
  }

  void _pickMember(User? member) {
    setState(() => _ctrlDropdownOwner.value = member);
    _requestSlots();
  }

  Widget _buildFilters() {
    return FilterToggle(
      children: [
        AppInfoRow(
          info: Text("Location"),
          child: AppDropdown<Location>(
            controller: _ctrlDropdownLocation,
            builder: (Location location) {
              return Text(location.key);
            },
            onChanged: (Location? location) {
              _ctrlDropdownLocation.value = location;
              _filterReservations();
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _ctrlDropdownLocation.value = null;
              _filterReservations();
            },
          ),
        ),
        AppInfoRow(
          info: Text("Show Courses"),
          child: Text("all/yes/no"),
        ),
      ],
    );
  }

  Widget _buildSlotPendingPanel() {
    return Column(
      children: [
        _buildFilters(),
        AppListView(
          items: _eventsFiltered,
          itemBuilder: (Slot slot) {
            return InkWell(
              onTap: () => _selectSlot(slot),
              child: Expanded(
                child: AppSlotTile(
                  slot: slot,
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.highlight_remove),
                      onPressed: () => _denyReservation(slot),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () => _acceptReservation(slot),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
