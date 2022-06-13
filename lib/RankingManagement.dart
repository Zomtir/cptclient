import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppDropdown.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppListView.dart';
import 'material/app/AppRankingTile.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/DropdownController.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;
import 'json/session.dart';
import 'json/ranking.dart';
import 'json/branch.dart';
import 'json/member.dart';

import 'RankingEditPage.dart';

class RankingManagementPage extends StatefulWidget {
  final Session session;

  RankingManagementPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RankingManagementPageState();
}

class RankingManagementPageState extends State<RankingManagementPage> {
  List<Ranking> _rankings = [];
  List<Ranking> _rankingsFiltered = [];
  bool _hideFilters = true;

  DropdownController<Member> _ctrlDropdownUser = DropdownController<Member>(items: []);
  DropdownController<Member> _ctrlDropdownJudge = DropdownController<Member>(items: []);
  DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: db.cacheBranches);
  RangeValues                _thresholdRange = RangeValues(0, 10);

  RankingManagementPageState();

  @override
  void initState() {
    super.initState();
    _getRankings();
  }

  Future<void> _getRankings() async {
    final response = await http.get(
      Uri.http(navi.server, 'ranking_list', {
        'user_id': '0',
        'branch_id': '0',
        'min': '0',
        'max': '0'}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(response.body);

    _rankings = List<Ranking>.from(list.map((model) => Ranking.fromJson(model)));
    _ctrlDropdownUser.items = Set<Member>.from(_rankings.map((model) => model.user)).toList();
    _ctrlDropdownJudge.items = Set<Member>.from(_rankings.map((model) => model.judge)).toList();

    _filterRankings();
  }

  void _filterRankings() {
    setState(() {
      _rankingsFiltered = _rankings.where((ranking) {
        bool userFilter = (_ctrlDropdownUser.value == null) ? true : (ranking.user == _ctrlDropdownUser.value);
        bool judgeFilter = (_ctrlDropdownJudge.value == null) ? true : (ranking.judge == _ctrlDropdownJudge.value);
        bool branchFilter = (_ctrlDropdownBranch.value == null) ? true : (
            ranking.branch == _ctrlDropdownBranch.value &&
            ranking.rank >= _thresholdRange.start &&
            ranking.rank <= _thresholdRange.end
        );
        return userFilter && judgeFilter && branchFilter;
      }).toList();
    });
  }

  void _createRanking() async {
    _selectRanking(Ranking.create());
  }

  void _selectRanking(Ranking ranking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RankingEditPage(session: widget.session, ranking: ranking, onUpdate: _getRankings)));
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Rankings"),
      ),
      body: AppBody(
        children: <Widget>[
          TextButton.icon(
            icon: _hideFilters ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.keyboard_arrow_up),
            label: _hideFilters ? Text('Show Filters') : Text ('Hide Filters'),
            onPressed: () => setState (() => _hideFilters = !_hideFilters),
          ),
          CollapseWidget(
            collapse: _hideFilters,
            children: [
              AppInfoRow(
                info: Text("User"),
                child: AppDropdown<Member>(
                  controller: _ctrlDropdownUser,
                  builder: (Member member) {return Text(member.key);},
                  onChanged: (Member? member) {
                    _ctrlDropdownUser.value = member;
                    _filterRankings();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlDropdownUser.value = null;
                    _filterRankings();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Judge"),
                child: AppDropdown<Member>(
                  controller: _ctrlDropdownJudge,
                  builder: (Member member) {return Text(member.key);},
                  onChanged: (Member? member) {
                    _ctrlDropdownJudge.value = member;
                    _filterRankings();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlDropdownJudge.value = null;
                    _filterRankings();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Branch"),
                child: AppDropdown<Branch>(
                  controller: _ctrlDropdownBranch,
                  builder: (Branch branch) {return Text(branch.title);},
                  onChanged: (Branch? branch) {
                    _ctrlDropdownBranch.value = branch;
                    _filterRankings();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _ctrlDropdownBranch.value = null;
                    _filterRankings();
                  },
                ),
              ),
              AppInfoRow(
                info: Text("Thresholds"),
                child: RangeSlider(
                  values: _thresholdRange,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (RangeValues values) {
                    _thresholdRange = values;
                    _filterRankings();
                  },
                  labels: RangeLabels("${_thresholdRange.start}","${_thresholdRange.end}"),
                ),
              ),
            ],
          ),
          AppButton(
            text: "New ranking",
            onPressed: _createRanking,
          ),
          AppListView<Ranking>(
            items: _rankingsFiltered,
            itemBuilder: (Ranking ranking) {
              return AppRankingTile(
                onTap: _selectRanking,
                ranking: ranking,
              );
            },
          ),
        ],
      ),
    );
  }

}
