import 'package:cptclient/api/admin/competence/competence.dart' as api_admin;
import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/layouts/FilterToggle.dart';
import 'package:cptclient/material/tiles/AppCompetenceTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/CompetenceEditPage.dart';
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompetenceOverviewPage extends StatefulWidget {
  final UserSession session;

  CompetenceOverviewPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => CompetenceOverviewPageState();
}

class CompetenceOverviewPageState extends State<CompetenceOverviewPage> {
  List<Competence> _competences = [];

  final FieldController<User> _ctrlUser = FieldController();
  //final FieldController<User> _ctrlJudge = FieldController();
  final FieldController<Skill> _ctrlSkill = FieldController();
  //RangeValues _ctrlSkillRange = RangeValues(0, 10);

  CompetenceOverviewPageState();

  @override
  void initState() {
    super.initState();

    _ctrlUser.callItems = () => api_regular.user_list(widget.session);
    //_ctrlJudge.callItems = () => api_regular.user_list(widget.session);
    _ctrlSkill.callItems = () => api_anon.skill_list();

    _update();
  }

  Future<void> _update() async {
    List<Competence> competences = await api_admin.competence_list(
        widget.session, _ctrlUser.value, _ctrlSkill.value);

    setState(() => _competences = competences);
  }

  Future<void> _handleSelect(Competence competence, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompetenceEditPage(
          session: widget.session,
          competence: competence,
          isDraft: isDraft,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCompetenceManagement),
      ),
      body: AppBody(
        children: <Widget>[
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.competenceUser,
                child: AppField<User>(
                  controller: _ctrlUser,
                  onChanged: (User? user) =>
                      setState(() => _ctrlUser.value = user),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.competenceSkill,
                child: AppField<Skill>(
                  controller: _ctrlSkill,
                  onChanged: (Skill? skill) =>
                      setState(() => _ctrlSkill.value = skill),
                ),
              ),
              /*AppInfoRow(
                info: Text("Thresholds"),
                child: RangeSlider(
                  values: _ctrlSkillRange,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (RangeValues values) {
                    _ctrlSkillRange = values;
                    _filterRankings();
                  },
                  labels: RangeLabels(
                      "${_ctrlSkillRange.start}", "${_ctrlSkillRange.end}"),
                ),
              ),*/
            ],
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: () => _handleSelect(Competence.fromVoid(), true),
          ),
          AppListView<Competence>(
            items: _competences,
            itemBuilder: (Competence competence) {
              return InkWell(
                onTap: () => _handleSelect(competence, false),
                child: AppCompetenceTile(
                  competence: competence,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
