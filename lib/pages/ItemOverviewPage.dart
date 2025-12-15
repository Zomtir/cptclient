import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/ItemCreatePage.dart';
import 'package:cptclient/pages/ItemDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemOverviewPage extends StatefulWidget {
  final UserSession session;

  ItemOverviewPage({super.key, required this.session});

  @override
  ItemOverviewPageState createState() => ItemOverviewPageState();
}

class ItemOverviewPageState extends State<ItemOverviewPage> {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    Result<List<Item>> result = await api_admin.item_list(widget.session);
    if (result is! Success) return;
    setState(() {
      _items = result.unwrap();
    });
  }

  void _handleSelect(Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(
          session: widget.session,
          itemID: item.id,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemCreatePage(
          session: widget.session,
          item: Item.fromVoid(),
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemOverview),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel<Item>(
            items: _items,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
