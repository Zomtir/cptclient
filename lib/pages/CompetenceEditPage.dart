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
import 'package:cptclient/material/tiles/AppRankingTile.dart';
import 'package:cptclient/static/server_ranking_admin.dart' as api_admin;
import 'package:cptclient/static/server_skill_anon.dart' as api_anon;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';

class CompetenceEditPage extends StatefulWidget {
  final Session session;
  final Competence ranking;
  final bool isDraft;

  CompetenceEditPage({super.key, required this.session, required this.ranking, required this.isDraft});

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
    _ctrlUser.value = widget.ranking.user;
    _ctrlSkill.value = widget.ranking.skill;
    _ctrlRank = widget.ranking.rank;
    _ctrlJudge.value = widget.ranking.judge;
    _ctrlDate.setDate(widget.ranking.date);
  }

  void _gatherRanking() {
    widget.ranking.user = _ctrlUser.value;
    widget.ranking.skill = _ctrlSkill.value;
    widget.ranking.rank = _ctrlRank;
    widget.ranking.judge = _ctrlJudge.value;
    widget.ranking.date = _ctrlDate.getDate();
  }

  void _submitRanking() async {
    _gatherRanking();

    final success = widget.isDraft ? await api_admin.ranking_create(widget.session, widget.ranking) : await api_admin.ranking_edit(widget.session, widget.ranking);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved ranking')));
    Navigator.pop(context);
  }

  void _deleteRanking() async {
    final success = await api_admin.ranking_delete(widget.session, widget.ranking);

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
          ranking: Competence.fromCompetence(widget.ranking),
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
        title: Text("Ranking"),
      ),
      body: AppBody(
        children: [
          if (widget.ranking.id != 0)
            Row(
              children: [
                Expanded(
                  child: AppRankingTile(
                    ranking: widget.ranking,
                  ),
                ),
                if (widget.session.right!.admin_competence)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _duplicateRanking,
                  ),
                if (widget.session.right!.admin_competence)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteRanking,
                  ),
              ],
            ),
          AppInfoRow(
            info: Text("User"),
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
            info: Text("Skill"),
            child: AppField<Skill>(
              controller: _ctrlSkill,
              onChanged: (Skill? skill) {
                setState(() => _ctrlSkill.value = skill);
              },
            ),
          ),
          AppInfoRow(
            info: Text("Level"),
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
            info: Text("Judge"),
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
            info: Text("Date"),
            child: DateTimeEdit(
              controller: _ctrlDate,
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _submitRanking,
          ),
        ],
      ),
    );
  }
}
