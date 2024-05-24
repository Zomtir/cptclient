import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/tiles/AppCompetenceTile.dart';
import 'package:cptclient/static/server_ranking_admin.dart' as api_admin;
import 'package:cptclient/static/server_skill_anon.dart' as api_anon;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompetenceEditPage extends StatefulWidget {
  final Session session;
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
            info: Text(AppLocalizations.of(context)!.competenceUser),
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
            info: Text(AppLocalizations.of(context)!.competenceSkill),
            child: AppField<Skill>(
              controller: _ctrlSkill,
              onChanged: (Skill? skill) {
                setState(() => _ctrlSkill.value = skill);
              },
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.competenceSkillRank),
            child: Slider(
              value: _ctrlRank.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (double value) {
                setState(() => _ctrlRank = value.toInt());
              },
              label: "$_ctrlRank",
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.competenceJudge),
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
            info: Text(AppLocalizations.of(context)!.competenceDate),
            child: DateTimeEdit(
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
