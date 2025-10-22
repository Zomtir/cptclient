import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/itemcat.dart' as api_admin;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

class ItemEditPage extends StatefulWidget {
  final UserSession session;
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
          content: Text("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.statusIsInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.item_create(widget.session, widget.item)
        : await api_admin.item_edit(widget.session, widget.item);

    if (!success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.item_delete(widget.session, widget.item)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemEdit),
        actions: [
          if (!widget.isDraft) IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) widget.item.buildCard(context),
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemCategory,
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
