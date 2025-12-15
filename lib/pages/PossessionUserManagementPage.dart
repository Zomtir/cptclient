import 'package:cptclient/api/admin/inventory/inventory.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/possession.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class PossessionUserManagementPage extends StatefulWidget {
  final UserSession session;

  PossessionUserManagementPage({super.key, required this.session});

  @override
  PossessionUserManagementPageState createState() => PossessionUserManagementPageState();
}

class PossessionUserManagementPageState extends State<PossessionUserManagementPage> {
  bool _locked = true;
  User? _user;
  List<Possession> _possessions = [];

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    Result<List<User>> result_users = await api_regular.user_list(widget.session);
    if (result_users is! Success) return;

    User? user;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_users.unwrap(), onPick: (item) => user = item),
    );

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _user = user);
    await _update();
  }

  Future<void> _update() async {
    Result<List<Possession>> result = await api_admin.possession_list(widget.session, _user!, null, null, null);
    if (result is! Success) return;

    setState(() {
      _possessions = result.unwrap();
      _possessions.sort();
      _locked = false;
    });
  }

  void _handleHandout(Possession possession) async {
    await api_admin.item_handout(widget.session, possession);
    _update();
  }

  void _handleRestock(Possession possession) async {
    Result<List<Stock>> result_stocks = await api_admin.stock_list(widget.session, null, possession.item);
    if (result_stocks is! Success) return;

    Stock? stock;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_stocks.unwrap(), onPick: (item) => stock = item),
    );

    if (stock == null) return;

    await api_admin.item_restock(widget.session, possession, stock!);
    _update();
  }

  void _handleReturn(Possession possession) async {
    await api_admin.item_return(widget.session, possession);
    _update();
  }

  void _handleCreate() async {
    Result<List<Item>> result_items = await api_admin.item_list(widget.session);
    if (result_items is! Success) return;

    Item? item;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_items.unwrap(), onPick: (e) => item = e),
    );

    if (item == null) return;

    await api_admin.possession_create(widget.session, _user!, item!);
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        locked: _locked,
        maxWidth: 1000,
        minWidth: 1000,
        children: <Widget>[
          _user!.buildTile(
            context,
            trailing: [
              IconButton(
                onPressed: _prepare,
                icon: Icon(Icons.refresh),
                tooltip: AppLocalizations.of(context)!.possessionUser,
              ),
            ],
          ),
          Divider(),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionItem)),
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionAcquisition)),
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionOwned)),
              DataColumn(label: Text(AppLocalizations.of(context)!.possessionPossessed)),
            ],
            rows: List<DataRow>.generate(_possessions.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(_possessions[index].item.buildEntry(context)),
                  DataCell(
                    Text(
                      _possessions[index].acquisitionDate != null
                          ? "${formatIsoDate(_possessions[index].acquisitionDate)}"
                          : AppLocalizations.of(context)!.undefined,
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Tooltip(
                          message: _possessions[index].owned
                              ? AppLocalizations.of(context)!.labelTrue
                              : AppLocalizations.of(context)!.labelFalse,
                          child: Icon(
                            Icons.catching_pokemon,
                            color: _possessions[index].owned ? Colors.green : Colors.red,
                          ),
                        ),
                        if (!_possessions[index].owned)
                          Tooltip(
                            message: AppLocalizations.of(context)!.inventoryOwnershipFromClubToUser,
                            child: IconButton(
                              icon: Icon(Icons.card_giftcard),
                              onPressed: () => _handleHandout(_possessions[index]),
                            ),
                          ),
                        if (_possessions[index].owned)
                          Tooltip(
                            message: AppLocalizations.of(context)!.inventoryOwnershipFromUserToClub,
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
                            message: AppLocalizations.of(context)!.inventoryPossessionFromUserToClub,
                            child: IconButton(
                              icon: Icon(Icons.redo),
                              onPressed: () => _handleReturn(_possessions[index]),
                            ),
                          ),
                        if (_possessions[index].owned)
                          Tooltip(
                            message: AppLocalizations.of(context)!.inventoryOwnershipFromUserDelete,
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
        ],
      ),
    );
  }
}
