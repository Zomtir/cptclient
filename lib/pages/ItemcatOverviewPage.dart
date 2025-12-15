import 'package:cptclient/api/admin/inventory/itemcat.dart' as api_admin;
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/ItemcatCreatePage.dart';
import 'package:cptclient/pages/ItemcatDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemcatOverviewPage extends StatefulWidget {
  final UserSession session;

  ItemcatOverviewPage({super.key, required this.session});

  @override
  ItemcatOverviewPageState createState() => ItemcatOverviewPageState();
}

class ItemcatOverviewPageState extends State<ItemcatOverviewPage> {
  List<ItemCategory> _itemcats = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    Result<List<ItemCategory>> result_itemcats = await api_admin.itemcat_list(widget.session);
    if (result_itemcats is! Success) return;
    setState(() {
      _itemcats = result_itemcats.unwrap();
    });
  }

  void _handleSelect(ItemCategory category) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemcatDetailPage(
          session: widget.session,
          category: category,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemcatCreatePage(
          session: widget.session,
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
          SearchablePanel(
            items: _itemcats,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
