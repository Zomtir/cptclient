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

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;
import 'json/session.dart';
import 'json/slot.dart';
import 'json/location.dart';

class ReservationManagementPage extends StatefulWidget {
  final Session session;

  ReservationManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ReservationManagementPageState();
}

class ReservationManagementPageState extends State<ReservationManagementPage> {
  List<Slot> _reservations = [];
  List<Slot> _reservationsFiltered = [];
  bool _hideFilters = true;

  DropdownController<int>      _ctrlDropdownUser = DropdownController<int>(items: []);
  DropdownController<Location> _ctrlDropdownLocation = DropdownController<Location>(items: db.cacheLocations);
  RangeValues                  _timeRange = RangeValues(1, 12);

  ReservationManagementPageState();

  @override
  void initState() {
    super.initState();
    _getReservations();
  }

  Future<void> _getReservations() async {
    final response = await http.get(
      Uri.http(navi.server, 'reservation_list', {'status': 'PENDING'}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));

    _reservations = List<Slot>.from(list.map((model) => Slot.fromJson(model)));
    _ctrlDropdownUser.items = Set<int>.from(_reservations.map((model) => model.user_id)).toList();

    _filterReservations();
  }

  void _filterReservations() {
    setState(() {
      _reservationsFiltered = _reservations.where((reservation) {
        bool userFilter = (_ctrlDropdownUser.value == null) ? true : (reservation.user_id == _ctrlDropdownUser.value);
        bool locationFilter = (_ctrlDropdownLocation.value == null) ? true : (reservation.location == _ctrlDropdownLocation.value);
        bool timeFilter = true; // TODO actually implement this
        return userFilter && locationFilter && timeFilter;
      }).toList();
    });
  }

  void _acceptReservation(Slot reservation) async {
    final response = await http.head(
      Uri.http(navi.server, 'reservation_accept', {'slot_id': reservation.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;
    _getReservations();
  }

  void _denyReservation(Slot reservation) async {
    final response = await http.head(
      Uri.http(navi.server, 'reservation_deny', {'slot_id': reservation.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;
    _getReservations();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Reservations"),
      ),
      body: AppBody(
        children: <Widget>[
          TextButton.icon(
            icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
            label: _hideFilters ? Text('Show Filters') : Text ('Hide Filters'),
            onPressed: () => setState (() => _hideFilters = !_hideFilters),
          ),
          CollapseWidget(
            collapse: _hideFilters,
            children: [
              AppInfoRow(
                info: Text("User"),
                child: AppDropdown<int>(
                  controller: _ctrlDropdownUser,
                  builder: (int member) {return Text(member.toString());},
                  onChanged: (int? member) {
                    _ctrlDropdownUser.value = member;
                    _filterReservations();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlDropdownUser.value = null;
                    _filterReservations();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Location"),
                child: AppDropdown<Location>(
                  controller: _ctrlDropdownLocation,
                  builder: (Location location) {return Text(location.key);},
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
                info: Text("Month in 2021"),
                child: RangeSlider(
                  values: _timeRange,
                  min: 1,
                  max: 12,
                  divisions: 10,
                  onChanged: (RangeValues values) {
                    _timeRange = values;
                    _filterReservations();
                  },
                  labels: RangeLabels("${_timeRange.start}","${_timeRange.end}"),
                ),
              ),
            ],
          ),
          AppListView<Slot>(
            items: _reservationsFiltered,
            itemBuilder: (Slot slot) {
              return Row(
                children: [
                  Expanded(
                    child: AppSlotTile(
                      onTap: (reservation) => {},
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
      ),
    );
  }

}
