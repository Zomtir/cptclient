import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
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
  final Club? club;
  final Item? item;

  PossessionClubManagementPage({super.key, required this.session, this.club, this.item});

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
    if (widget.club == null) {
      List<Club> clubs = await api_anon.club_list();
      Club? club = await showTilePicker(context: context, items: clubs);

      if (club == null) {
        Navigator.pop(context);
        return;
      }
      setState(() => _club = club);
    } else {
      setState(() => _club = widget.club);
    }

    _update();
  }

  Future<void> _update() async {
    List<Possession> possessions = await api_admin.possession_list(widget.session, null, widget.item, false, _club!);
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
        maxWidth: 1000,
        children: <Widget>[
          if (widget.club == null) AppButton(
            text: AppLocalizations.of(context)!.possessionClub,
            onPressed: _prepare,
            leading: Icon(Icons.refresh),
          ),
          Divider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: DataTable(
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
            ),
          ),
        ],
      ),
    );
  }
}
