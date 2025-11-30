import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/ItemEditPage.dart';
import 'package:flutter/material.dart';

class ItemOverviewPage extends StatefulWidget {
  final UserSession session;

  ItemOverviewPage({super.key, required this.session});

  @override
  ItemOverviewPageState createState() => ItemOverviewPageState();
}

class ItemOverviewPageState extends State<ItemOverviewPage> {
  GlobalKey<SearchablePanelState<Item>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Item> items = await api_admin.item_list(widget.session);
    searchPanelKey.currentState?.update(items);
  }

  void _handleSelect(Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditPage(
          session: widget.session,
          item: item,
          isDraft: false,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditPage(
          session: widget.session,
          item: Item.fromVoid(),
          isDraft: true,
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
            key: searchPanelKey,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
