import 'package:cptclient/json/competence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppRankingTile.dart';
import 'package:cptclient/material/tiles/AppSkillTile.dart';
import 'package:cptclient/static/server_ranking_regular.dart' as server;
import 'package:flutter/material.dart';

class RankingOverviewPage extends StatefulWidget {
  final Session session;

  RankingOverviewPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => RankingOverviewPageState();
}

class RankingOverviewPageState extends State<RankingOverviewPage> {
  List<Competence> _rankings = [];
  List<(Skill, int)> _summary = [];

  RankingOverviewPageState();

  @override
  void initState() {
    super.initState();
    _requestRankings();
    _requestSummary();
  }

  Future<void> _requestRankings() async {
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
        title: Text("Rankings"),
      ),
      body: AppBody(
        children: <Widget>[
          AppListView<(Skill, int)>(
            items: _summary,
            itemBuilder: ((Skill, int) skillrank) {
              return AppSkillTile(
                skill: skillrank.$1,
                trailing: [Text(skillrank.$2.toString())],
              );
            },
          ),
          Divider(),
          AppListView<Competence>(
            items: _rankings,
            itemBuilder: (Competence ranking) {
              return AppRankingTile(
                ranking: ranking,
              );
            },
          ),
        ],
      ),
    );
  }

}
