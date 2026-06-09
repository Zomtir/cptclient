import 'package:cptclient/api/admin/discipline/discipline.dart' as api_admin;
import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class DisciplineDetailPage extends StatefulWidget {
  final UserSession session;
  final Discipline discipline;

  DisciplineDetailPage({super.key, required this.session, required this.discipline});

  @override
  DisciplineDetailPageState createState() => DisciplineDetailPageState();
}

class DisciplineDetailPageState extends State<DisciplineDetailPage> {
  DisciplineDetailPageState();

  void submit() async {
    if (widget.discipline.name.isEmpty) {
      messageText("${AppLocalizations.of(context)!.disciplineName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    var result = await api_admin.discipline_edit(widget.session, widget.discipline);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  void delete() async {
    var result = await api_admin.discipline_delete(widget.session, widget.discipline);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageDisciplineEdit),
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
            info: AppLocalizations.of(context)!.disciplineName,
            child: AppTile(
              child: Text(widget.discipline.name),
              trailing: [
                IconButton(
                  onPressed: () => clipText(widget.discipline.name),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TextEditDialog(
                        initialValue: widget.discipline.name,
                        minLength: 1,
                        maxLength: 250,
                        onConfirm: (key) {
                          widget.discipline.name = key;
                          submit();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
