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
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemCreatePage extends StatefulWidget {
  final UserSession session;
  final Item? item;

  ItemCreatePage(
      {super.key, required this.session, this.item});

  @override
  ItemCreatePageState createState() => ItemCreatePageState();
}

class ItemCreatePageState extends State<ItemCreatePage> {
  final TextEditingController _ctrlName = TextEditingController();
  final FieldController<ItemCategory> _ctrlCategory = FieldController();

  ItemCreatePageState();

  @override
  void initState() {
    super.initState();
    Item item = widget.item ?? Item.fromVoid();
    _ctrlName.text = item.name;
    _ctrlCategory.value = item.category;
    _update();
  }

  Future<void> _update() async {
    _ctrlCategory.callItems = () => api_admin.itemcat_list(widget.session);
  }

  void _handleSubmit() async {
    if (_ctrlName.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Item item = Item.fromVoid();
    item.name = _ctrlName.text;
    item.category = _ctrlCategory.value;

    var result = await api_admin.item_create(widget.session, item);
    if (result is! Success) return;

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
