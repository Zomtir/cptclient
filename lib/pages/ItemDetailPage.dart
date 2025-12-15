import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/itemcat.dart' as api_admin;
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  final UserSession session;
  final int itemID;

  ItemDetailPage(
      {super.key, required this.session, required this.itemID});

  @override
  ItemDetailPageState createState() => ItemDetailPageState();
}

class ItemDetailPageState extends State<ItemDetailPage> {
  bool _locked = true;
  Item? item;

  ItemDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  Future<void> update() async {
    setState(() => _locked = true);
    Result<Item> result_item = await api_admin.item_info(widget.session, widget.itemID);
    if (result_item is! Success)  return;
    setState(() => item = result_item.unwrap());
    setState(() => _locked = false);
  }

  void submit() async {
    if (item!.name.isEmpty) {
      messageText("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    var result = await api_admin.item_edit(widget.session, widget.itemID, item!);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  void delete() async {
    var result = await api_admin.item_delete(widget.session, widget.itemID);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemEdit),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: delete,
          ),
        ],
      ),
      body: AppBody(
        locked: _locked,
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemName,
            child: AppTile(
              child: Text(item!.name),
              trailing: [
                IconButton(
                  onPressed: () => clipText(item!.name),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => TextEditDialog(
                      initialValue: item!.name,
                      minLength: 1,
                      maxLength: 30,
                      onConfirm: (String t) {
                        setState(() => item!.name = t);
                        submit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemCategory,
            child: ListTile(
              title: Text(item!.category?.name ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(item!.category?.name ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      var result = await api_admin.itemcat_list(widget.session);
                      if (result is! Success) return;
                      showDialog(
                        context: context,
                        builder: (context) => PickerDialog<ItemCategory>(
                          items: result.unwrap(),
                          onPick: (itemcat) {
                            item!.category = itemcat;
                            submit();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
