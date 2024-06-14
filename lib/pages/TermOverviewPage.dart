import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/pages/TermEditPage.dart';
import 'package:cptclient/static/server_term_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermOverviewPage extends StatefulWidget {
  final UserSession session;
  final Club club;

  TermOverviewPage({super.key, required this.session, required this.club});

  @override
  TermOverviewPageState createState() => TermOverviewPageState();
}

class TermOverviewPageState extends State<TermOverviewPage> {
  GlobalKey<SearchablePanelState<Term>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Term> terms = await api_admin.term_list(widget.session, widget.club);
    searchPanelKey.currentState?.setItems(terms);
  }

  void _handleSelect(Term term) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermEditPage(
          session: widget.session,
          term: term,
          isDraft: false,
          club: widget.club,
        ),
      ),
    );

    _update();
  }

  void _createTerm() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermEditPage(
          session: widget.session,
          term: Term.fromVoid(),
          isDraft: true,
          club: widget.club,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTermManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createTerm,
          ),
          SearchablePanel(
            key: searchPanelKey,
            builder: (Term term, Function(Term)? onSelect) => InkWell(
              onTap: () => onSelect?.call(term),
              child: term.buildTile(),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
