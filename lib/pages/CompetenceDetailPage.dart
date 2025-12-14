import 'package:cptclient/api/admin/competence/competence.dart' as api_admin;
import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/NumberSliderDialog.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:cptclient/pages/CompetenceCreatePage.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class CompetenceDetailPage extends StatefulWidget {
  final UserSession session;
  final int competenceID;

  CompetenceDetailPage({super.key, required this.session, required this.competenceID});

  @override
  State<StatefulWidget> createState() => CompetenceDetailPageState();
}

class CompetenceDetailPageState extends State<CompetenceDetailPage> {
  bool _locked = true;
  Competence? competence;

  CompetenceDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    _locked = true;
    var result = await api_admin.competence_info(widget.session, widget.competenceID);
    if (result is! Success) return;
    setState(() => competence = result.unwrap());
    _locked = false;
  }

  void submit() async {
    var result = await api_admin.competence_edit(widget.session, widget.competenceID, competence!);
    if (result is! Success) return;
    update();
  }

  void _delete() async {
    var result = await api_admin.competence_delete(widget.session, widget.competenceID);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  void _duplicate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompetenceCreatePage(
          session: widget.session,
          competence: Competence.fromCompetence(competence!),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) return LoadingWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCompetenceEdit),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _duplicate,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _delete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceUser,
            child: competence!.user!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkill,
            child: competence!.skill!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkillRank,
            child: ListTile(
              title: Text(competence!.rank.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(competence!.rank.toString()),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => NumberSliderDialog(
                          initialValue: competence!.rank,
                          min: competence!.skill!.min,
                          max: competence!.skill!.max,
                          onConfirm: (rank) {
                            competence!.rank = rank;
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
          // TODO xxx compare
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkillRank,
            child: AppTile(
              child: Text(competence!.rank.toString()),
              trailing: [
                IconButton(
                  onPressed: () => clipText(competence!.rank.toString()),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NumberSliderDialog(
                        initialValue: competence!.rank,
                        min: competence!.skill!.min,
                        max: competence!.skill!.max,
                        onConfirm: (rank) {
                          competence!.rank = rank;
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
            info: AppLocalizations.of(context)!.competenceJudge,
            child: ListTile(
              title: Text(competence!.judge.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(competence!.judge.toString()),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      var result = await api_admin.user_list(widget.session);
                      if (result is! Success) return;
                      showDialog(
                        context: context,
                        builder: (context) => PickerDialog<User>(
                          items: result.unwrap(),
                          onPick: (user) {
                            competence!.judge = user;
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
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceDate,
            child: AppTile(
              child: Text(competence!.date.fmtDate(context)),
              trailing: [
                IconButton(
                  onPressed: () => clipText(formatIsoDate(competence!.date) ?? ''),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DatePicker(
                      initialDate: competence!.date,
                      onConfirm: (DateTime dt) {
                        setState(() => competence!.date = dt);
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
