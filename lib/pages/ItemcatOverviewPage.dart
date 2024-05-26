import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/pages/ItemcatEditPage.dart';
import 'package:cptclient/static/server_itemcat_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemcatOverviewPage extends StatefulWidget {
  final Session session;

  ItemcatOverviewPage({super.key, required this.session});

  @override
  ItemcatOverviewPageState createState() => ItemcatOverviewPageState();
}

class ItemcatOverviewPageState extends State<ItemcatOverviewPage> {
  GlobalKey<SearchablePanelState<ItemCategory>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<ItemCategory> itemcats = await api_admin.itemcat_list(widget.session);
    searchPanelKey.currentState?.setItems(itemcats);
  }

  void _handleSelect(ItemCategory category) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemcatEditPage(
          session: widget.session,
          category: category,
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
        builder: (context) => ItemcatEditPage(
          session: widget.session,
          category: ItemCategory.fromVoid(),
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
        title: Text(AppLocalizations.of(context)!.pageItemcatOverview),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          SearchablePanel(
            key: searchPanelKey,
            builder: (ItemCategory category, Function(ItemCategory)? onSelect) => InkWell(
              onTap: () => onSelect?.call(category),
              child: category.buildTile(),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
