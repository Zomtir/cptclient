import 'package:cptclient/api/admin/skill/skill.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/SkillCreatePage.dart';
import 'package:cptclient/pages/SkillDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class SkillOverviewPage extends StatefulWidget {
  final UserSession session;

  SkillOverviewPage({super.key, required this.session});

  @override
  SkillOverviewPageState createState() => SkillOverviewPageState();
}

class SkillOverviewPageState extends State<SkillOverviewPage> {
  GlobalKey<SearchablePanelState<Skill>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    Result<List<Skill>> result = await api_admin.skill_list(widget.session);
    if (result is! Success) return;
    searchPanelKey.currentState?.populate(result.unwrap());
  }

  void _handleSelect(Skill skill) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillDetailPage(
          session: widget.session,
          skill: skill,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillCreatePage(
          session: widget.session,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSkillManagement),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel(
            key: searchPanelKey,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
