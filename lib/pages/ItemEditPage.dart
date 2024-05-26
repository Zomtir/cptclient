import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/tiles/AppItemTile.dart';
import 'package:cptclient/static/server_item_admin.dart' as api_admin;
import 'package:cptclient/static/server_itemcat_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemEditPage extends StatefulWidget {
  final Session session;
  final Item item;
  final bool isDraft;

  ItemEditPage(
      {super.key, required this.session, required this.item, required this.isDraft});

  @override
  ItemEditPageState createState() => ItemEditPageState();
}

class ItemEditPageState extends State<ItemEditPage> {
  final TextEditingController _ctrlName = TextEditingController();
  final FieldController<ItemCategory> _ctrlCategory = FieldController();

  ItemEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
    _applyInfo();
  }

  Future<void> _update() async {
    _ctrlCategory.callItems = () => api_admin.itemcat_list(widget.session);
  }

  void _applyInfo() {
    _ctrlName.text = widget.item.name;
    _ctrlCategory.value = widget.item.category;
  }

  void _gatherInfo() {
    widget.item.name = _ctrlName.text;
    widget.item.category = _ctrlCategory.value;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.item.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.item_create(widget.session, widget.item)
        : await api_admin.item_edit(widget.session, widget.item);

    if (!success) return;

    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await api_admin.item_delete(widget.session, widget.item)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppItemTile(
              item: widget.item,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteUser,
                ),
              ],
            ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.itemName),
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.itemCategory),
            child: AppField<ItemCategory>(
              controller: _ctrlCategory,
              onChanged: (ItemCategory? category) {
                setState(() => _ctrlCategory.value = category);
              },
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
