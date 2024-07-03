import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppItemcatTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/static/server_itemcat_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemcatEditPage extends StatefulWidget {
  final UserSession session;
  final ItemCategory category;
  final bool isDraft;

  ItemcatEditPage(
      {super.key, required this.session, required this.category, required this.isDraft});

  @override
  ItemcatEditPageState createState() => ItemcatEditPageState();
}

class ItemcatEditPageState extends State<ItemcatEditPage> {
  final TextEditingController _ctrlName = TextEditingController();

  ItemcatEditPageState();

  @override
  void initState() {
    super.initState();
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlName.text = widget.category.name;
  }

  void _gatherInfo() {
    widget.category.name = _ctrlName.text;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.category.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.itemcat_create(widget.session, widget.category)
        : await api_admin.itemcat_edit(widget.session, widget.category);

    if (!success) return;

    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await api_admin.itemcat_delete(widget.session, widget.category)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemcatEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppItemcatTile(
              category: widget.category,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteUser,
                ),
              ],
            ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemcatName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
