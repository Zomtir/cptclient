import 'package:cptclient/api/admin/club/term.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/TermCreatePage.dart';
import 'package:cptclient/pages/TermDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ClubTermOverviewPage extends StatefulWidget {
  final UserSession session;
  final Club club;

  ClubTermOverviewPage({super.key, required this.session, required this.club});

  @override
  ClubTermOverviewPageState createState() => ClubTermOverviewPageState();
}

class ClubTermOverviewPageState extends State<ClubTermOverviewPage> {
  GlobalKey<SearchablePanelState<Term>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    update();
  }

  Future<void> update() async {
    var result_terms = await api_admin.term_list(widget.session, widget.club);
    if (result_terms is! Success) return;
    searchPanelKey.currentState?.populate(result_terms.unwrap());
  }

  void _handleSelect(Term term) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermDetailPage(
          session: widget.session,
          termID: term.id,
        ),
      ),
    );

    update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermCreatePage(
          session: widget.session,
          club: widget.club,
        ),
      ),
    );

    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTermManagement),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _handleCreate,
            tooltip: AppLocalizations.of(context)!.actionCreate,
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
