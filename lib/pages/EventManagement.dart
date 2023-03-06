import 'dart:html';

import 'package:cptclient/material/DateTimeController.dart';
import 'package:flutter/material.dart';

import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';

import '../material/DateTimeEdit.dart';
import 'EventDetailPage.dart';

import '../static/format.dart';
import '../static/server.dart' as server;
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
  DateTimeController _ctrlDateBegin = DateTimeController(DateUtils.dateOnly(DateTime.now()));
  DateTimeController _ctrlDateEnd = DateTimeController(DateUtils.dateOnly(DateTime.now().add(Duration(days: 30))));

  List<Slot> _events = [];
  List<Slot> _eventsFiltered = [];
  bool _hideFilters = true;
  final _filterDaysMax = 366;

  int _panelIndex = 0;
  List<String> _panelStatus = ['PENDING', 'OCCURRING', 'REJECTED', 'CANCELED'];

  DropdownController<User> _ctrlDropdownUser = DropdownController<User>(items: server.cacheMembers);
  DropdownController<Location> _ctrlDropdownLocation = DropdownController<Location>(items: server.cacheLocations);

  EventManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestSlots();
  }

  Future<void> _requestSlots() async {
    _events = await server.event_list(widget.session, _ctrlDateBegin.dateTime, _ctrlDateBegin.dateTime, _panelStatus[_panelIndex], _ctrlDropdownUser.value);
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

  void _selectSlot(Slot slot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          onUpdate: _requestSlots,
          isDraft: false,
          isOwner: false,
          isAdmin: true,
        ),
      ),
    );
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
            child: DateTimeEdit(controller: _ctrlDateBegin, onUpdate: _pickDateBegin, hideTime: true),
          ),
          AppInfoRow(
            info: Text("End Date"),
            child: DateTimeEdit(controller: _ctrlDateEnd, onUpdate: _pickDateEnd, hideTime: true),
          ),
          AppInfoRow(
            info: Text("User"),
            child: AppDropdown<User>(
              controller: _ctrlDropdownUser,
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
    DateTime newDateEnd = _ctrlDateEnd.dateTime;

    if (newDateEnd.isBefore(newDateBegin)) newDateEnd = newDateBegin;

    if (newDateEnd.isAfter(newDateBegin.add(Duration(days: _filterDaysMax)))) newDateEnd = newDateBegin.add(Duration(days: _filterDaysMax));

    setState(() {
      _ctrlDateBegin.dateTime = newDateBegin;
      _ctrlDateEnd.dateTime = newDateEnd;
    });
    _requestSlots();
  }

  Future _pickDateEnd(DateTime newDateEnd) async {
    DateTime newDateBegin = _ctrlDateBegin.dateTime;

    if (newDateBegin.isAfter(newDateEnd)) newDateBegin = newDateEnd;

    if (newDateBegin.isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) newDateBegin = newDateEnd.add(Duration(days: -_filterDaysMax));

    setState(() {
      _ctrlDateBegin.dateTime = newDateBegin;
      _ctrlDateEnd.dateTime = newDateEnd;
    });
    _requestSlots();
  }

  void _pickMember(User? member) {
    setState(() => _ctrlDropdownUser.value = member);
    _requestSlots();
  }

  Widget _buildFilters() {
    return Column(
      children: [
        TextButton.icon(
          icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
          label: _hideFilters ? Text('Show Filters') : Text('Hide Filters'),
          onPressed: () => setState(() => _hideFilters = !_hideFilters),
        ),
        CollapseWidget(
          collapse: _hideFilters,
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
            return Row(
              children: [
                Expanded(
                  child: AppSlotTile(
                    onTap: _selectSlot,
                    slot: slot,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.highlight_remove),
                  onPressed: () => _denyReservation(slot),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () => _acceptReservation(slot),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
