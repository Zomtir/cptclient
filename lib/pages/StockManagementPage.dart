import 'package:cptclient/api/admin/inventory/inventory.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/dialogs/StockEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/PossessionClubManagementPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class StockManagementPage extends StatefulWidget {
  final UserSession session;

  StockManagementPage({super.key, required this.session});

  @override
  StockManagementPageState createState() => StockManagementPageState();
}

class StockManagementPageState extends State<StockManagementPage> {
  Club? _club;
  List<Stock> _stocks = [];

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    Result<List<Club>> result_clubs = await api_anon.club_list();
    if (result_clubs is! Success) {
      Navigator.pop(context);
      return;
    }

    Club? club;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_clubs.unwrap(), onPick: (e) => club = e),
    );

    if (club == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _club = club);
    _update();
  }

  Future<void> _update() async {
    Result<List<Stock>> result_stocks = await api_admin.stock_list(widget.session, _club, null);
    if (result_stocks is! Success) return;

    setState(() {
      _stocks = result_stocks.unwrap();
      _stocks.sort();
    });
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

    Stock? stock = Stock(id: 0, club: _club!, item: item!, storage: "", owned: 1, loaned: 0);

    showDialog(
      context: context,
      builder: (context) => StockEditDialog(
        initialValue: stock,
        onConfirm: (Stock stock) {
          api_admin.stock_create(widget.session, stock);
          _update();
        },
      ),
    );
  }

  void _handleEdit(Stock stock) async {
    await showDialog(
      context: context,
      builder: (context) => StockEditDialog(
        initialValue: stock,
        onDelete: () => api_admin.stock_delete(widget.session, stock),
        onConfirm: (Stock stock) => api_admin.stock_edit(widget.session, stock),
      ),
    );

    _update();
  }

  void _viewLoans(Stock stock) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PossessionClubManagementPage(
          session: widget.session,
          club: stock.club,
          item: stock.item,
        ),
      ),
    );
    _update();
  }

  void _handleLoan(Stock stock) async {
    Result<List<User>> result_users = await api_regular.user_list(widget.session);
    if (result_users is! Success) return;

    User? user;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: result_users.unwrap(), onPick: (e) => user = e),
    );

    if (user == null) return;

    await api_admin.item_loan(widget.session, stock, user!);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageStockManagement),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        minWidth: 600,
        children: <Widget>[
          AppButton(
            text: AppLocalizations.of(context)!.stockClub,
            onPressed: _prepare,
            leading: Icon(Icons.refresh),
          ),
          Divider(),
          DataTable(
            columnSpacing: 0,
            columns: [
              DataColumn(
                label: Text(
                  "${AppLocalizations.of(context)!.stockItem}\n${AppLocalizations.of(context)!.stockStorage}",
                ),
              ),
              DataColumn(label: Text(AppLocalizations.of(context)!.stockOwned)),
              DataColumn(label: Text(AppLocalizations.of(context)!.stockLoaned)),
            ],
            rows: List<DataRow>.generate(_stocks.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _handleEdit(_stocks[index]),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_stocks[index].item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(_stocks[index].storage, style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text("${_stocks[index].owned}")),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.list_alt_outlined),
                          onPressed: () => _viewLoans(_stocks[index]),
                        ),
                        Text("${_stocks[index].loaned}"),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () => _handleLoan(_stocks[index]),
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
