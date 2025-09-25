import 'package:cptclient/api/admin/discipline/discipline.dart' as api_admin;
import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/pages/DisciplineCreatePage.dart';
import 'package:cptclient/pages/DisciplineInfoPage.dart';
import 'package:flutter/material.dart';

class DisciplineOverviewPage extends StatefulWidget {
  final UserSession session;

  DisciplineOverviewPage({super.key, required this.session});

  @override
  DisciplineOverviewPageState createState() => DisciplineOverviewPageState();
}

class DisciplineOverviewPageState extends State<DisciplineOverviewPage> {
  GlobalKey<SearchablePanelState<Discipline>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Discipline> disciplines = await api_admin.discipline_list(widget.session);
    searchPanelKey.currentState?.update(disciplines);
  }

  void _handleSelect(Discipline discipline) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisciplineInfoPage(
          session: widget.session,
          discipline: discipline,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisciplineCreatePage(
          session: widget.session,
          discipline: Discipline.fromVoid(),
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageDisciplineManagement),
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
