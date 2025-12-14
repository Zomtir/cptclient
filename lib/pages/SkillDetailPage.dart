import 'package:cptclient/api/admin/skill/skill.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/NumberRangeDialog.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class SkillDetailPage extends StatefulWidget {
  final UserSession session;
  final Skill skill;

  SkillDetailPage({super.key, required this.session, required this.skill});

  @override
  SkillDetailPageState createState() => SkillDetailPageState();
}

class SkillDetailPageState extends State<SkillDetailPage> {
  SkillDetailPageState();

  void submit() async {
    if (widget.skill.key.isEmpty) {
      messageText("${AppLocalizations.of(context)!.skillKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (widget.skill.title.isEmpty) {
      messageText("${AppLocalizations.of(context)!.skillTitle} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    var result = await api_admin.skill_edit(widget.session, widget.skill);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  void delete() async {
    var result = await api_admin.skill_delete(widget.session, widget.skill);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSkillEdit),
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
            info: AppLocalizations.of(context)!.skillKey,
            child: AppTile(
              child: Text(widget.skill.key),
              trailing: [
                IconButton(
                  onPressed: () => clipText(widget.skill.key),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TextEditDialog(
                        initialValue: widget.skill.key,
                        minLength: 1,
                        maxLength: 10,
                        onConfirm: (key) {
                          widget.skill.key = key;
                          submit();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.skillTitle,
            child: AppTile(
              child: Text(widget.skill.title),
              trailing: [
                IconButton(
                  onPressed: () => clipText(widget.skill.title),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => TextEditDialog(
                        initialValue: widget.skill.title,
                        minLength: 1,
                        maxLength: 250,
                        onConfirm: (key) {
                          widget.skill.title = key;
                          submit();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.skillRange,
            child: AppTile(
              child: Text("${widget.skill.min} - ${widget.skill.max}"),
              trailing: [
                IconButton(
                  onPressed: () => clipText("${widget.skill.min} - ${widget.skill.max}"),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NumberRangeDialog(
                        initialRange: RangeValues(widget.skill.min.toDouble(), widget.skill.max.toDouble()),
                        onConfirm: (range) {
                          widget.skill.min = range.start.toInt();
                          widget.skill.max = range.end.toInt();
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
