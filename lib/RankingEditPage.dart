import 'package:cptclient/material/app/AppRankingTile.dart';
import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppDropdown.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppButton.dart';
import 'material/DropdownController.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;
import 'json/session.dart';
import 'json/ranking.dart';
import 'json/member.dart';
import 'json/branch.dart';

class RankingEditPage extends StatefulWidget {
  final Session session;
  final Ranking ranking;
  final void Function() onUpdate;

  RankingEditPage({Key? key, required this.session, required this.ranking, required this.onUpdate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RankingEditPageState();
}

class RankingEditPageState extends State<RankingEditPage> {
  DropdownController<Member>    _ctrlRankingUser = DropdownController<Member>(items: []);
  DropdownController<Branch>    _ctrlRankingBranch = DropdownController<Branch>(items: db.cacheBranches);
  int                           _rankingLevel = 0;
  DropdownController<Member>    _ctrlRankingJudge = DropdownController<Member>(items: []);
  TextEditingController         _ctrlRankingDate = TextEditingController();

  RankingEditPageState();

  @override
  void initState() {
    super.initState();
    _applyRanking();
    _getMembers();
  }

  Future<void> _getMembers() async {
    final response = await http.get(
      Uri.http(navi.server, 'user_member_list'),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));
    var members = List<Member>.from(list.map((model) => Member.fromJson(model)));

    setState(() {
      _ctrlRankingUser.items = members;
      _ctrlRankingJudge.items = members;
    });
  }

  void _applyRanking() {
    _ctrlRankingUser.value = widget.ranking.user;
    _ctrlRankingBranch.value = widget.ranking.branch;
    _rankingLevel = widget.ranking.rank;
    _ctrlRankingJudge.value = widget.ranking.judge;
    _ctrlRankingDate.text = DateFormat("yyyy-MM-dd HH:mm").format(widget.ranking.date);
  }

  void _gatherRanking() {
    widget.ranking.user = _ctrlRankingUser.value;
    widget.ranking.branch = _ctrlRankingBranch.value;
    widget.ranking.rank = _rankingLevel;
    widget.ranking.judge = _ctrlRankingJudge.value;
    widget.ranking.date = DateFormat("yyyy-MM-dd HH:mm").parse(_ctrlRankingDate.text, false);
  }

  void _deleteRanking() async {
    final response = await http.head(
      Uri.http(navi.server, 'ranking_delete', {'ranking': widget.ranking.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted ranking')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  void _duplicateRanking() {
    Ranking _ranking = Ranking.fromRanking(widget.ranking);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RankingEditPage(session: widget.session, ranking: _ranking, onUpdate: widget.onUpdate)));
  }

  void _submitRanking() async {
    _gatherRanking();

    final response = await http.post(
      Uri.http(navi.server, widget.ranking.id == 0 ? 'ranking_create' : 'ranking_edit'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Token': widget.session.token,
      },
      body: json.encode(widget.ranking),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved ranking')));
    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Ranking"),
      ),
      body: AppBody(
        children: [
          if (widget.ranking.id != 0) Row(
            children: [
              Expanded(
                child: AppRankingTile(
                  onTap: (ranking) => {},
                  ranking: widget.ranking,
                ),
              ),
              if (widget.session.user!.admin_rankings) IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _duplicateRanking,
              ),
              if (widget.session.user!.admin_rankings) IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteRanking,
              ),
            ],
          ),
          AppInfoRow(
            info: Text("Member"),
            child: AppDropdown<Member>(
              hint: Text("Select member"),
              controller: _ctrlRankingUser,
              builder: (Member member) {return Text(member.key);},
              onChanged: (Member? member) {
                setState(() {
                  _ctrlRankingUser.value = member;
                });
              },
            ),
          ),
          AppInfoRow(
            info: Text("Branch"),
            child: AppDropdown<Branch>(
              controller: _ctrlRankingBranch,
              builder: (Branch branch) {return Text(branch.title);},
              onChanged: (Branch? branch) {
                setState(() => _ctrlRankingBranch.value = branch);
              },
            ),
          ),
          AppInfoRow(
            info: Text("Level"),
            child: Slider(
              value: _rankingLevel.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (double value) {
                setState(() => _rankingLevel = value.toInt());
              },
              label: "$_rankingLevel",
            ),
          ),
          AppInfoRow(
            info: Text("Judge"),
            child: AppDropdown<Member>(
              hint: Text("Select member"),
              controller: _ctrlRankingJudge,
              builder: (Member member) {return Text(member.key);},
              onChanged: (Member? member) {
                setState(() {
                  _ctrlRankingJudge.value = member;
                });
              },
            ),
          ),
          AppInfoRow(
            info: Text("Date"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlRankingDate,
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
