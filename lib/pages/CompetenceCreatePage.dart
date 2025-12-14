import 'package:cptclient/api/admin/competence/competence.dart' as api_admin;
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/SkillRankField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class CompetenceCreatePage extends StatefulWidget {
  final UserSession session;
  final Competence? competence;

  CompetenceCreatePage({super.key, required this.session, this.competence});

  @override
  State<StatefulWidget> createState() => CompetenceCreatePageState();
}

class CompetenceCreatePageState extends State<CompetenceCreatePage> {
  final FieldController<User> _ctrlUser = FieldController();
  final FieldController<Skill> _ctrlSkill = FieldController();
  int _ctrlRank = 0;
  final FieldController<User> _ctrlJudge = FieldController();
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());

  CompetenceCreatePageState();

  @override
  void initState() {
    super.initState();
    Competence competence = widget.competence ?? Competence.fromVoid();
    _ctrlUser.value = competence.user;
    _ctrlSkill.value = competence.skill;
    _ctrlRank = competence.rank;
    _ctrlJudge.value = competence.judge;
    _ctrlDate.setDate(competence.date);
  }

  void submit() async {
    Competence competence = Competence(
      user: _ctrlUser.value,
      skill: _ctrlSkill.value,
      rank: _ctrlRank,
      judge: _ctrlJudge.value,
      date: _ctrlDate.getDate(),
    );

    var result = await api_admin.competence_create(widget.session, competence);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCompetenceEdit),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceUser,
            child: AppField<User>(
              controller: _ctrlUser,
              onChanged: (User? user) {
                setState(() {
                  _ctrlUser.value = user;
                });
              },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkill,
            child: AppField<Skill>(
              controller: _ctrlSkill,
              onChanged: (Skill? skill) {
                setState(() => _ctrlSkill.value = skill);
              },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkillRank,
            child: SkillRankField(
              controller: _ctrlSkill,
              rank: _ctrlRank,
              onChanged: (Skill? skill, int rank) => setState(() {
                _ctrlSkill.value = skill;
                _ctrlRank = rank;
              }),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceJudge,
            child: AppField<User>(
              controller: _ctrlJudge,
              onChanged: (User? user) {
                setState(() {
                  _ctrlJudge.value = user;
                });
              },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceDate,
            child: DateTimeField(
              controller: _ctrlDate,
              showTime: false,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
