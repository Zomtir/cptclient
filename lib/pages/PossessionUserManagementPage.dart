import 'package:cptclient/api/admin/inventory/inventory.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/format.dart';
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

  void _handleRestock(Possession possession) async {
    List<Stock> stocks = await api_admin.stock_list(widget.session, null, possession.item);
    Stock? stock = await showTilePicker(context: context, items: stocks);

    if (stock == null) return;

    await api_admin.item_restock(widget.session, possession, stock);
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
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionAcquisition)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionOwned)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.possessionPossessed)),
                ],
                rows: List<DataRow>.generate(_possessions.length, (index) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(_possessions[index].item.buildEntry()),
                      DataCell(Text(_possessions[index].acquisitionDate != null
                          ? "${formatIsoDate(_possessions[index].acquisitionDate)}"
                          : AppLocalizations.of(context)!.undefined)),
                      DataCell(
                        Row(
                          children: [
                            Tooltip(
                              message: "${_possessions[index].owned}", // TODO locale
                              child: Icon(Icons.catching_pokemon, color: _possessions[index].owned ? Colors.green : Colors.red),
                            ),
                            if (!_possessions[index].owned)
                              Tooltip(
                                message: "Give ownership of the item to the user", // TODO locale
                                child: IconButton(
                                  icon: Icon(Icons.card_giftcard),
                                  onPressed: () => _handleHandout(_possessions[index]),
                                ),
                              ),
                            if (_possessions[index].owned)
                              Tooltip(
                                message: "Assign this item back on a club stock", // TODO locale
                                child: IconButton(
                                  icon: Icon(Icons.storefront),
                                  onPressed: () => _handleRestock(_possessions[index]),
                                ),
                              ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            if (!_possessions[index].owned)
                              Tooltip(
                                message: "Physically return the item", // TODO locale
                                child: IconButton(
                                  icon: Icon(Icons.redo),
                                  onPressed: () => _handleReturn(_possessions[index]),
                                ),
                              ),
                            if (_possessions[index].owned)
                              Tooltip(
                                message: "The item is no longer available", // TODO
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _handleDelete(_possessions[index]),
                                ),
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
