import 'package:cptclient/api/admin/inventory/itemcat.dart' as api_admin;
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemcatDetailPage extends StatefulWidget {
  final UserSession session;
  final ItemCategory category;

  ItemcatDetailPage({super.key, required this.session, required this.category});

  @override
  ItemcatDetailPageState createState() => ItemcatDetailPageState();
}

class ItemcatDetailPageState extends State<ItemcatDetailPage> {
  final TextEditingController _ctrlName = TextEditingController();

  ItemcatDetailPageState();

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

  void submit() async {
    _gatherInfo();

    if (widget.category.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.statusIsInvalid}",
          ),
        ),
      );
      return;
    }

    var result = await api_admin.itemcat_edit(widget.session, widget.category);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  void delete() async {
    var result = await api_admin.itemcat_delete(widget.session, widget.category);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageItemcatEdit),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: delete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemcatName,
            child: AppTile(
              child: Text(widget.category.name),
              trailing: [
                IconButton(
                  onPressed: () => clipText(widget.category.name),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => TextEditDialog(
                      initialValue: widget.category.name,
                      minLength: 1,
                      maxLength: 30,
                      onConfirm: (String t) {
                        setState(() => widget.category.name = t);
                        submit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
