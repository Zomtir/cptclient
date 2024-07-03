import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/static/format.dart';
import 'package:cptclient/static/server_inventory_admin.dart' as api_admin;
import 'package:cptclient/static/server_item_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PossessionUserManagementPage extends StatefulWidget {
  final UserSession session;

  PossessionUserManagementPage({super.key, required this.session});

  @override
  PossessionUserManagementPageState createState() => PossessionUserManagementPageState();
}

class PossessionUserManagementPageState extends State<PossessionUserManagementPage> {
  User? _user;
  List<Possession> _possessions = [];

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    List<User> users = await api_regular.user_list(widget.session);
    User? user = await showTilePicker(context: context, items: users);

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _user = user);
    _update();
  }

  Future<void> _update() async {
    List<Possession> possessions = await api_admin.possession_list(widget.session, _user!, null, null, null);
    possessions.sort();

    setState(() {
      _possessions = possessions;
    });
  }

  void _handleHandout(Possession possession) async {
    await api_admin.item_handout(widget.session, possession);
    _update();
  }

  void _handleHandback(Possession possession) async {
    await api_admin.item_handback(widget.session, possession);
    _update();
  }

  void _handleReturn(Possession possession) async {
    await api_admin.item_return(widget.session, possession);
    _update();
  }

  void _handleCreate() async {
    List<Item> items = await api_admin.item_list(widget.session);
    Item? item = await showTilePicker(context: context, items: items);

    if (item == null) return;

    await api_admin.possession_create(widget.session, _user!, item);
    _update();
  }

  void _handleDelete(Possession possession) async {
    await api_admin.possession_delete(widget.session, possession);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagePossessionUser),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppButton(
            text: AppLocalizations.of(context)!.possessionUser,
            onPressed: _prepare,
            leading: Icon(Icons.refresh),
          ),
          if (_user != null) AppUserTile(user: _user!),
          Divider(),
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
                  DataColumn(label: Text(AppLocalizations.of(context)!.actionEdit)),
                ],
                rows: List<DataRow>.generate(_possessions.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text("${_possessions[index].item.toFieldString()}")),
                      DataCell(Text(_possessions[index].club != null
                          ? "${_possessions[index].club!.toFieldString()}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(Text(_possessions[index].transferDate != null
                          ? "${formatNaiveDate(_possessions[index].transferDate)}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(
                        Tooltip(
                          message: "${_possessions[index].owned}",
                          child: _possessions[index].owned ? Icon(Icons.catching_pokemon) : Icon(Icons.front_hand),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            if (!_possessions[index].owned)
                              IconButton(
                                icon: Icon(Icons.card_giftcard),
                                onPressed: () => _handleHandout(_possessions[index]),
                              ),
                            if (_possessions[index].owned && _possessions[index].club != null)
                              IconButton(
                                icon: Icon(Icons.do_not_disturb),
                                onPressed: () => _handleHandback(_possessions[index]),
                              ),
                            if (!_possessions[index].owned && _possessions[index].club != null)
                              IconButton(
                                icon: Icon(Icons.redo),
                                onPressed: () => _handleReturn(_possessions[index]),
                              ),
                            if (_possessions[index].owned)
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _handleDelete(_possessions[index]),
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
          AppButton(
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
            leading: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
