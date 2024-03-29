import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCompetenceTile.dart';
import 'package:cptclient/material/tiles/AppSkillTile.dart';
import 'package:cptclient/static/server_ranking_regular.dart' as server;
import 'package:flutter/material.dart';

class CompetenceSummaryPage extends StatefulWidget {
  final Session session;

  CompetenceSummaryPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => CompetenceSummaryPageState();
}

class CompetenceSummaryPageState extends State<CompetenceSummaryPage> {
  List<Competence> _rankings = [];
  List<(Skill, int)> _summary = [];

  CompetenceSummaryPageState();

  @override
  void initState() {
    super.initState();
    _requestList();
    _requestSummary();
  }

  Future<void> _requestList() async {
    List<Competence> rankings = await server.competence_list(widget.session);
    setState(() => _rankings = rankings);
  }

  Future<void> _requestSummary() async {
    List<(Skill, int)> summary = await server.competence_summary(widget.session);
    setState(() => _summary = summary);
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Competence"),
      ),
      body: AppBody(
        children: <Widget>[
          DataTable(
            columns: const [
              DataColumn(label: Text('Skill')),
              DataColumn(label: Text('Min')),
              DataColumn(label: Text('Max')),
              DataColumn(label: Text('Current')),
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
            items: _rankings,
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
