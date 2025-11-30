import 'package:cptclient/api/admin/skill/skill.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/SkillEditPage.dart';
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
    List<Skill> skills = await api_admin.skill_list(widget.session);
    searchPanelKey.currentState?.update(skills);
  }

  void _handleSelect(Skill skill) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillEditPage(
          session: widget.session,
          skill: skill,
          isDraft: false,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillEditPage(
          session: widget.session,
          skill: Skill.fromVoid(),
          isDraft: true,
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
