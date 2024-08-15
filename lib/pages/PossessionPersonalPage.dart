import 'package:cptclient/api/regular/inventory/inventory.dart' as api_regular;
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionClub)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionTransfer)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionOwned)),
                ],
                rows: List<DataRow>.generate(_possessions.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text("${_possessions[index].item.toFieldString()}")),
                      DataCell(Text(_possessions[index].club != null
                          ? "${_possessions[index].club!.toFieldString()}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(Text(_possessions[index].transferDate != null
                          ? "${formatIsoDate(_possessions[index].transferDate)}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(
                        Tooltip(
                          message: "${_possessions[index].owned}",
                          child: _possessions[index].owned ? Icon(Icons.catching_pokemon) : Icon(Icons.front_hand),
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
