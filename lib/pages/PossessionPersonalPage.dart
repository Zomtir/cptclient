import 'package:cptclient/api/regular/inventory/inventory.dart' as api_regular;
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class PossessionPersonalPage extends StatefulWidget {
  final UserSession session;

  PossessionPersonalPage({super.key, required this.session});

  @override
  PossessionPersonalPageState createState() => PossessionPersonalPageState();
}

class PossessionPersonalPageState extends State<PossessionPersonalPage> {
  List<Possession> _possessions = [];

  @override
  void initState() {
    super.initState();

    _update();
  }

  Future<void> _update() async {
    List<Possession> possessions = await api_regular.possession_list(widget.session, null, null);
    possessions.sort();

    setState(() {
      _possessions = possessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagePossessionPersonal),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionItem)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionAcquisition)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionOwned)),
                ],
                rows: List<DataRow>.generate(_possessions.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(_possessions[index].item.buildEntry(context)),
                      DataCell(Text(_possessions[index].acquisitionDate != null
                          ? "${formatIsoDate(_possessions[index].acquisitionDate)}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(
                        Tooltip(
                          message: "${_possessions[index].owned}", // TODO locale
                          child: Icon(Icons.catching_pokemon, color: _possessions[index].owned ? Colors.green : Colors.red),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
