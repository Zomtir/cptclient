import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppListView.dart';
import 'material/app/AppRankingTile.dart';
import 'material/app/AppSkillTile.dart';

import 'static/serverRankingMember.dart' as server;
import 'json/session.dart';
import 'json/ranking.dart';
import 'json/skill.dart';

class RankingOverviewPage extends StatefulWidget {
  final Session session;

  RankingOverviewPage({Key? key, required this.session}) : super(key: key);

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
    return new Scaffold(
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
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          AppListView<Ranking>(
            items: _rankings,
            itemBuilder: (Ranking ranking) {
              return AppRankingTile(
                onTap: (ranking) => {},
                ranking: ranking,
              );
            },
          ),
        ],
      ),
    );
  }

}
