import 'package:cptclient/api/admin/inventory/itemcat.dart' as api_admin;
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ItemcatCreatePage extends StatefulWidget {
  final UserSession session;


  ItemcatCreatePage({super.key, required this.session});

  @override
  ItemcatCreatePageState createState() => ItemcatCreatePageState();
}

class ItemcatCreatePageState extends State<ItemcatCreatePage> {
  final TextEditingController _ctrlName = TextEditingController();

  ItemcatCreatePageState();

  void _handleSubmit() async {
    if (_ctrlName.text.isEmpty || _ctrlName.text.length > 30) {
      messageText("${AppLocalizations.of(context)!.itemcatName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    ItemCategory itemcat = ItemCategory.fromVoid();
    itemcat.name = _ctrlName.text;

    var result = await api_admin.itemcat_create(widget.session, itemcat);
    if (result is! Success) return;

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
          AppInfoRow(
            info: AppLocalizations.of(context)!.itemcatName,
            child: TextField(controller: _ctrlName, maxLines: 1, maxLength: 30),
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
