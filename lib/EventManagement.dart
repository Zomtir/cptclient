import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/app/AppBody.dart';
import 'package:cptclient/material/app/AppDropdown.dart';
import 'package:cptclient/material/app/AppInfoRow.dart';
import 'package:cptclient/material/app/AppListView.dart';
import 'package:cptclient/material/app/AppSlotTile.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/DropdownController.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EventDetailPage.dart';
import 'material/PanelSwiper.dart';
import 'material/app/DatePicker.dart';
import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;
import 'json/session.dart';
import 'json/slot.dart';
import 'json/location.dart';
import 'json/user.dart';

class EventManagementPage extends StatefulWidget {
  final Session session;

  EventManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventManagementPageState();
}

class EventManagementPageState extends State<EventManagementPage> {
  DateTime _dateBegin = DateTime.now();
  DateTime _dateEnd = DateTime.now().add(Duration(days: 30));

  List<Slot> _events = [];
  List<Slot> _eventsFiltered = [];
  bool _hideFilters = true;
  final _filterDaysMax = 366;

  int _panelIndex = 0;
  List<String> _panelStatus = ['PENDING', 'OCCURRING', 'REJECTED', 'CANCELED'];

  DropdownController<User> _ctrlDropdownUser = DropdownController<User>(items: db.cacheMembers);
  DropdownController<Location> _ctrlDropdownLocation = DropdownController<Location>(items: db.cacheLocations);

  EventManagementPageState();

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    final response = await http.get(
      Uri.http(navi.server, 'reservation_list', {
        'begin': webDate(_dateBegin),
        'end': webDate(_dateEnd),
        'status': _panelStatus[_panelIndex],
        'user_id': (_ctrlDropdownUser.value?.id ?? 0).toString(),
      }),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));
    _events = List<Slot>.from(list.map((model) => Slot.fromJson(model)));

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
          onUpdate: _loadSlots,
          draft: false,
        ),
      ),
    );
  }

  void _acceptReservation(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'reservation_accept', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;
    _loadSlots();
  }

  void _denyReservation(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'reservation_deny', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;
    _loadSlots();
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
            child: Text(niceDate(_dateBegin)),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _pickDateBegin,
            ),
          ),
          AppInfoRow(
            info: Text("End Date"),
            child: Text(niceDate(_dateEnd)),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: _pickDateEnd,
            ),
          ),
          AppInfoRow(
            info: Text("User"),
            child: AppDropdown<User>(
              controller: _ctrlDropdownUser,
              builder: (User member) {
                return Text("${member.firstname} ${member.lastname}");
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
              _loadSlots();
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

  Future _pickDateBegin() async {
    DateTime? newDateBegin = await showAppDatePicker(
      context: context,
      initialDate: _dateBegin,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDateBegin == null) return;

    DateTime newDateEnd = _dateEnd;

    if (_dateEnd.isBefore(newDateBegin)) newDateEnd = newDateBegin;

    if (_dateEnd.isAfter(newDateBegin.add(Duration(days: _filterDaysMax)))) newDateEnd = newDateBegin.add(Duration(days: _filterDaysMax));

    setState(() {
      _dateBegin = newDateBegin;
      _dateEnd = newDateEnd;
    });
    _loadSlots();
  }

  Future _pickDateEnd() async {
    DateTime? newDateEnd = await showAppDatePicker(
      context: context,
      initialDate: _dateEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDateEnd == null) return;

    DateTime newDateBegin = _dateBegin;

    if (_dateBegin.isAfter(newDateEnd)) newDateBegin = newDateEnd;

    if (_dateBegin.isBefore(newDateEnd.add(Duration(days: -_filterDaysMax)))) newDateBegin = newDateEnd.add(Duration(days: -_filterDaysMax));

    setState(() {
      _dateBegin = newDateBegin;
      _dateEnd = newDateEnd;
    });
    _loadSlots();
  }

  void _pickMember(User? member) {
    setState(() => _ctrlDropdownUser.value = member);
    _loadSlots();
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
