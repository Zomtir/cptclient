import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/stock.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/static/server_club_anon.dart' as api_anon;
import 'package:cptclient/static/server_inventory_admin.dart' as api_admin;
import 'package:cptclient/static/server_item_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockManagementPage extends StatefulWidget {
  final Session session;

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
    List<Stock> stocks = await api_admin.stock_list(widget.session, _club!);
    setState(() {
      _stocks = stocks;
    });
  }

  void _handleCreate() async {
    List<Item> items = await api_admin.item_list(widget.session);
    Item? item = await showTilePicker(context: context, items: items);

    if (item == null) return;

    Stock stock = Stock(club: _club!, item: item, owned: 1, loaned: 0);
    await api_admin.stock_edit(widget.session, stock);

    _update();
  }

  void _handleChange(Stock stock, int delta) async {
    int overhead = stock.owned - stock.loaned;
    if (overhead + delta < 0) return;
    stock.owned = stock.owned + delta;

    await api_admin.stock_edit(widget.session, stock);

    _update();
  }

  void _handleLoan(Stock stock) async {
    List<User> users = await api_regular.user_list(widget.session);
    User? user = await showTilePicker(context: context, items: users);

    if (user == null) return;

    await api_admin.item_loan(widget.session, stock, user);

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageStockManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            text: AppLocalizations.of(context)!.stockClub,
            onPressed: _prepare,
            leading: Icon(Icons.refresh),
          ),
          Divider(),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.stockItem)),
              DataColumn(label: Text(AppLocalizations.of(context)!.stockOwned)),
              DataColumn(label: Text(AppLocalizations.of(context)!.stockLoaned)),
            ],
            rows: List<DataRow>.generate(_stocks.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${_stocks[index].item.name}")),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _handleChange(_stocks[index], 1),
                        ),
                        Text("${_stocks[index].owned}"),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _handleChange(_stocks[index], -1),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Text("${_stocks[index].loaned}"),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () => _handleLoan(_stocks[index]),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
          Divider(),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
    );
  }
}
