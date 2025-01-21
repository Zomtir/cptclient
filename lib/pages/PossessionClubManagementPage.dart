import 'package:cptclient/api/admin/inventory/inventory.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/format.dart';
import 'package:flutter/material.dart';

class PossessionClubManagementPage extends StatefulWidget {
  final UserSession session;
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
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionAcquisition)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.actionEdit)),
                ],
                rows: List<DataRow>.generate(_possessions.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(_possessions[index].user.buildEntry()),
                      DataCell(_possessions[index].item.buildEntry()),
                      DataCell(Text("${formatIsoDate(_possessions[index].acquisitionDate)}")),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.undo),
                              onPressed: () => _handleReturn(_possessions[index]),
                            ),
                            PopupMenuButton<VoidCallback>(
                              onSelected: (fn) => fn(),
                              itemBuilder: (context) => [
                                PopupMenuItem<VoidCallback>(
                                  value: () => _handleHandout(_possessions[index]),
                                  child: ListTile(title: Text("Handout"), leading: Icon(Icons.card_giftcard)),
                                ),
                              ],
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
