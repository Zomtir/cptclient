import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server_club_anon.dart' as api_anon;
import 'package:cptclient/static/server_inventory_admin.dart' as api_admin;
import 'package:cptclient/static/server_item_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PossessionClubManagementPage extends StatefulWidget {
  final Session session;

  PossessionClubManagementPage({super.key, required this.session});

  @override
  PossessionClubManagementPageState createState() => PossessionClubManagementPageState();
}

class PossessionClubManagementPageState extends State<PossessionClubManagementPage> {
  Club? _club;
  List<Possession> _possessions = [];

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    List<Club> clubs = await api_anon.club_list();
    Club? club = await showTilePicker(context: context, items: clubs);

    if (club == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _club = club);
    _update();
  }

  Future<void> _update() async {
    List<Possession> possessions = await api_admin.possession_list(widget.session, null, false, _club!);
    possessions.sort();

    setState(() {
      _possessions = possessions;
    });
  }

  void _handleReturn(Possession possession) async {
    await api_admin.item_return(widget.session, possession);

    _update();
  }

  void _handleHandout(Possession possession) async {
    await api_admin.item_handout(widget.session, possession);

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagePossessionClub),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            text: AppLocalizations.of(context)!.possessionClub,
            onPressed: _prepare,
            leading: Icon(Icons.refresh),
          ),
          Divider(),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionUser)),
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionItem)),
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionTransfer)),
              DataColumn(label: Text(AppLocalizations.of(context)!.actionEdit)),
            ],
            rows: List<DataRow>.generate(_possessions.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${_possessions[index].user.toFieldString()}")),
                  DataCell(Text("${_possessions[index].item.toFieldString()}")),
                  DataCell(Text("${formatNaiveDate(_possessions[index].transferDate)}")),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.undo),
                          onPressed: () => _handleReturn(_possessions[index]),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.card_giftcard),
                          onPressed: () => _handleHandout(_possessions[index]),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
