import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/static/server_inventory_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    List<(User, int, int, int)> stats =
        await api_admin.event_statistic_packlist(widget.session, widget.event, _ctrlCategories);
    stats.sort((a, b) => a.$1.compareTo(b.$1));
    setState(() => _stats = stats);
    _missing[0] = _stats.length - _stats.where((stat) => stat.$2 > 0).length;
    _missing[1] = _stats.length - _stats.where((stat) => stat.$3 > 0).length;
    _missing[2] = _stats.length - _stats.where((stat) => stat.$4 > 0).length;
  }

  void _handleCategories(int index) async {
    List<ItemCategory> categories = await api_regular.itemcat_list(widget.session);
    ItemCategory? category = await showTilePicker(context: context, items: categories);

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
          AppEventTile(
            event: widget.event,
          ),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.user)),
              DataColumn(
                label: InkWell(
                  child: Text(_ctrlCategories[0]?.name ?? AppLocalizations.of(context)!.undefined),
                  onTap: () => _handleCategories(0),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(_ctrlCategories[1]?.name ?? AppLocalizations.of(context)!.undefined),
                  onTap: () => _handleCategories(1),
                ),
              ),
              DataColumn(
                label: InkWell(
                  child: Text(_ctrlCategories[2]?.name ?? AppLocalizations.of(context)!.undefined),
                  onTap: () => _handleCategories(2),
                ),
              ),
            ],
            rows: [
              ...List<DataRow>.generate(_stats.length, (index) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text("${_stats[index].$1.toFieldString()}")),
                    DataCell(Text("${_stats[index].$2}")),
                    DataCell(Text("${_stats[index].$3}")),
                    DataCell(Text("${_stats[index].$4}")),
                  ],
                );
              }),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text(AppLocalizations.of(context)!.labelMissing, style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${_missing[0]}")),
                  DataCell(Text("${_missing[1]}")),
                  DataCell(Text("${_missing[2]}")),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
