import 'package:flutter/material.dart';

import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppRankingTile.dart';
import 'package:cptclient/material/CollapseWidget.dart';
import 'package:cptclient/material/DropdownController.dart';

import 'static/server.dart' as server;
import 'static/serverRankingAdmin.dart' as server;
import 'json/session.dart';
import 'json/ranking.dart';
import 'json/branch.dart';
import 'json/user.dart';

import 'RankingAdminPage.dart';

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

  DropdownController<User> _ctrlDropdownUser = DropdownController<User>(items: []);
  DropdownController<User> _ctrlDropdownJudge = DropdownController<User>(items: []);
  DropdownController<Branch> _ctrlDropdownBranch = DropdownController<Branch>(items: server.cacheBranches);
  RangeValues                _thresholdRange = RangeValues(0, 10);

  RankingManagementPageState();

  @override
  void initState() {
    super.initState();
    _requestRankings();
  }

  Future<void> _requestRankings() async {
    _rankings = await server.ranking_list(widget.session, null, null);
    _ctrlDropdownUser.items = Set<User>.from(_rankings.map((model) => model.user)).toList();
    _ctrlDropdownJudge.items = Set<User>.from(_rankings.map((model) => model.judge)).toList();

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => RankingAdminPage(session: widget.session, ranking: ranking, onUpdate: _requestRankings)));
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
                child: AppDropdown<User>(
                  controller: _ctrlDropdownUser,
                  builder: (User user) {return Text(user.key);},
                  onChanged: (User? user) {
                    _ctrlDropdownUser.value = user;
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
                child: AppDropdown<User>(
                  controller: _ctrlDropdownJudge,
                  builder: (User user) {return Text(user.key);},
                  onChanged: (User? user) {
                    _ctrlDropdownJudge.value = user;
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
            leading: Icon(Icons.add),
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
