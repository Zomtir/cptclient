import 'package:cptclient/json/branch.dart';
import 'package:cptclient/json/ranking.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/AppDropdown.dart';
import 'package:cptclient/material/tiles/AppRankingTile.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_ranking_admin.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RankingAdminPage extends StatefulWidget {
  final Session session;
  final Ranking ranking;
  final bool isDraft;

  RankingAdminPage({super.key, required this.session, required this.ranking, required this.isDraft});

  @override
  State<StatefulWidget> createState() => RankingAdminPageState();
}

class RankingAdminPageState extends State<RankingAdminPage> {
  final DropdownController<User> _ctrlRankingUser = DropdownController<User>(items: []);
  final DropdownController<Branch> _ctrlRankingBranch = DropdownController<Branch>(items: server.cacheBranches);
  int _rankingLevel = 0;
  final DropdownController<User> _ctrlRankingJudge = DropdownController<User>(items: []);
  final TextEditingController _ctrlRankingDate = TextEditingController();

  RankingAdminPageState();

  @override
  void initState() {
    super.initState();
    _getMembers();
    _applyRanking();
  }

  Future<void> _getMembers() async {
    List<User> users = await server.user_list(widget.session);

    setState(() {
      _ctrlRankingUser.items = users;
      _ctrlRankingJudge.items = users;
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

  void _submitRanking() async {
    _gatherRanking();

    final success = widget.isDraft ? await server.ranking_create(widget.session, widget.ranking) : await server.ranking_edit(widget.session, widget.ranking);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved ranking')));
    Navigator.pop(context);
  }

  void _deleteRanking() async {
    final success = await server.ranking_delete(widget.session, widget.ranking);

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
        builder: (context) => RankingAdminPage(
          session: widget.session,
          ranking: Ranking.fromRanking(widget.ranking),
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
            child: AppDropdown<User>(
              hint: Text("Select member"),
              controller: _ctrlRankingUser,
              builder: (User user) {
                return Text(user.key);
              },
              onChanged: (User? user) {
                setState(() {
                  _ctrlRankingUser.value = user;
                });
              },
            ),
          ),
          AppInfoRow(
            info: Text("Branch"),
            child: AppDropdown<Branch>(
              controller: _ctrlRankingBranch,
              builder: (Branch branch) {
                return Text(branch.title);
              },
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
            child: AppDropdown<User>(
              hint: Text("Select member"),
              controller: _ctrlRankingJudge,
              builder: (User user) {
                return Text(user.key);
              },
              onChanged: (User? user) {
                setState(() {
                  _ctrlRankingJudge.value = user;
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
