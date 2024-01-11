import 'package:cptclient/json/ranking.dart';
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
  List<Ranking> _rankings = [];
  List<Skill> _summary = [];

  RankingOverviewPageState();

  @override
  void initState() {
    super.initState();
    _requestRankings();
    _requestSummary();
  }

  Future<void> _requestRankings() async {
    List<Ranking> rankings = await server.ranking_list(widget.session);
    setState(() => _rankings = rankings);
  }

  Future<void> _requestSummary() async {
    List<Skill> summary = await server.ranking_summary(widget.session);
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
          AppListView<Skill>(
            items: _summary,
            itemBuilder: (Skill skill) {
              return AppSkillTile(
                skill: skill,
              );
            },
          ),
          Divider(),
          AppListView<Ranking>(
            items: _rankings,
            itemBuilder: (Ranking ranking) {
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
