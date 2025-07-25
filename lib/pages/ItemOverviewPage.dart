import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
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
    searchPanelKey.currentState?.setItems(items);
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
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          SearchablePanel<Item>(
            key: searchPanelKey,
            builder: (Item item, Function(Item)? onSelect) => InkWell(
              onTap: () => onSelect?.call(item),
              child: item.buildTile(context),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
