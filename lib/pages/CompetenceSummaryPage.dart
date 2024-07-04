import 'package:cptclient/api/regular/competence/competence.dart' as server;
import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/tiles/AppCompetenceTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompetenceSummaryPage extends StatefulWidget {
  final UserSession session;

  CompetenceSummaryPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => CompetenceSummaryPageState();
}

class CompetenceSummaryPageState extends State<CompetenceSummaryPage> {
  List<Competence> _competences = [];
  List<(Skill, int)> _summary = [];

  CompetenceSummaryPageState();

  @override
  void initState() {
    super.initState();
    _requestList();
    _requestSummary();
  }

  Future<void> _requestList() async {
    List<Competence> competences = await server.competence_list(widget.session);
    setState(() => _competences = competences);
  }

  Future<void> _requestSummary() async {
    List<(Skill, int)> summary = await server.competence_summary(widget.session);
    setState(() => _summary = summary);
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCompetencePersonal),
      ),
      body: AppBody(
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.competenceSkill)),
              DataColumn(label: Text(AppLocalizations.of(context)!.skillRangeMin)),
              DataColumn(label: Text(AppLocalizations.of(context)!.skillRangeMax)),
              DataColumn(label: Text(AppLocalizations.of(context)!.competenceSkillRank)),
            ],
            rows: List<DataRow>.generate(_summary.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text("${_summary[index].$1.title}")),
                  DataCell(Text("${_summary[index].$1.min}")),
                  DataCell(Text("${_summary[index].$1.max}")),
                  DataCell(Text("${_summary[index].$2}")),
                ],
              );
            }),
          ),
          Divider(),
          AppListView<Competence>(
            items: _competences,
            itemBuilder: (Competence competence) {
              return AppCompetenceTile(
                competence: competence,
              );
            },
          ),
        ],
      ),
    );
  }

}
