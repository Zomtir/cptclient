import 'package:cptclient/api/admin/event/event.dart' as api_admin;
import 'package:cptclient/api/regular/inventory/inventory.dart' as api_regular;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventStatisticPacklistPage extends StatefulWidget {
  final UserSession session;
  final Event event;

  EventStatisticPacklistPage({super.key, required this.session, required this.event});

  @override
  EventStatisticPacklistPageState createState() => EventStatisticPacklistPageState();
}

class EventStatisticPacklistPageState extends State<EventStatisticPacklistPage> {
  EventStatisticPacklistPageState();

  final List<ItemCategory?> _ctrlCategories = List<ItemCategory?>.filled(3, null);
  List<(User, int, int, int)> _stats = [];
  final List<int> _missing = List<int>.filled(3, 0);

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    var result = await api_admin.event_statistic_packlist(widget.session, widget.event, _ctrlCategories);
    if (result is! Success) return;

    List<(User, int, int, int)> stats = result.unwrap();
    stats.sort((a, b) => a.$1.compareTo(b.$1));
    setState(() => _stats = stats);
    _missing[0] = _stats.length - _stats.where((stat) => stat.$2 > 0).length;
    _missing[1] = _stats.length - _stats.where((stat) => stat.$3 > 0).length;
    _missing[2] = _stats.length - _stats.where((stat) => stat.$4 > 0).length;
  }

  void _handleCategories(int index) async {
    Result<List<ItemCategory>> result_categories = await api_regular.itemcat_list(widget.session);
    if (result_categories is! Success) return;
    ItemCategory? category;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_categories.unwrap(), onPick: (item) => category = item),
    );
    setState(() => _ctrlCategories[index] = category);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventStatisticPacklist),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.user)),
              DataColumn(
                label: TextButton.icon(
                  label: Text(_ctrlCategories[0]?.name ?? AppLocalizations.of(context)!.undefined),
                  icon: Icon(Icons.edit),
                  onPressed: () => _handleCategories(0),
                ),
              ),
              DataColumn(
                label: TextButton.icon(
                  label: Text(_ctrlCategories[1]?.name ?? AppLocalizations.of(context)!.undefined),
                  icon: Icon(Icons.edit),
                  onPressed: () => _handleCategories(1),
                ),
              ),
              DataColumn(
                label: TextButton.icon(
                  label: Text(_ctrlCategories[2]?.name ?? AppLocalizations.of(context)!.undefined),
                  icon: Icon(Icons.edit),
                  onPressed: () => _handleCategories(2),
                ),
              ),
            ],
            rows: [
              ...List<DataRow>.generate(_stats.length, (index) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(_stats[index].$1.buildEntry(context)),
                    DataCell(Text("${_stats[index].$2}")),
                    DataCell(Text("${_stats[index].$3}")),
                    DataCell(Text("${_stats[index].$4}")),
                  ],
                );
              }),
              DataRow(
                cells: <DataCell>[
                  DataCell(
                    Text(AppLocalizations.of(context)!.labelMissing, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataCell(Text("${_missing[0]}")),
                  DataCell(Text("${_missing[1]}")),
                  DataCell(Text("${_missing[2]}")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
