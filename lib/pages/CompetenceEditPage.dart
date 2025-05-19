import 'package:cptclient/api/admin/competence/competence.dart' as api_admin;
import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
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
import 'package:cptclient/material/tiles/AppCompetenceTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

class CompetenceEditPage extends StatefulWidget {
  final UserSession session;
  final Competence competence;
  final bool isDraft;

  CompetenceEditPage({super.key, required this.session, required this.competence, required this.isDraft});

  @override
  State<StatefulWidget> createState() => CompetenceEditPageState();
}

class CompetenceEditPageState extends State<CompetenceEditPage> {
  final FieldController<User> _ctrlUser = FieldController();
  final FieldController<Skill> _ctrlSkill = FieldController();
  int _ctrlRank = 0;
  final FieldController<User> _ctrlJudge = FieldController();
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());

  CompetenceEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
    _applyRanking();
  }

  Future<void> _update() async {
    _ctrlUser.callItems = () => api_regular.user_list(widget.session);
    _ctrlSkill.callItems = () => api_anon.skill_list();
    _ctrlJudge.callItems = () => api_regular.user_list(widget.session);
  }

  void _applyRanking() {
    _ctrlUser.value = widget.competence.user;
    _ctrlSkill.value = widget.competence.skill;
    _ctrlRank = widget.competence.rank;
    _ctrlJudge.value = widget.competence.judge;
    _ctrlDate.setDate(widget.competence.date);
  }

  void _gatherRanking() {
    widget.competence.user = _ctrlUser.value;
    widget.competence.skill = _ctrlSkill.value;
    widget.competence.rank = _ctrlRank;
    widget.competence.judge = _ctrlJudge.value;
    widget.competence.date = _ctrlDate.getDate();
  }

  void _submitRanking() async {
    _gatherRanking();

    final success = widget.isDraft ? await api_admin.competence_create(widget.session, widget.competence) : await api_admin.competence_edit(widget.session, widget.competence);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved ranking')));
    Navigator.pop(context);
  }

  void _deleteRanking() async {
    final success = await api_admin.competence_delete(widget.session, widget.competence);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted ranking')));
    Navigator.pop(context);
  }

  Future<void> _duplicateRanking() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompetenceEditPage(
          session: widget.session,
          competence: Competence.fromCompetence(widget.competence),
          isDraft: true,
        ),
      ),
    );

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
          if (!widget.isDraft)
            Row(
              children: [
                Expanded(
                  child: AppCompetenceTile(
                    competence: widget.competence,
                    trailing: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: _duplicateRanking,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _deleteRanking,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            info: AppLocalizations.of(context)!.competenceSkill,
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
            onPressed: _submitRanking,
          ),
        ],
      ),
    );
  }
}
