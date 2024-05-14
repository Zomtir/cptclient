import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/pages/TermEditPage.dart';
import 'package:cptclient/static/server_term_admin.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermOverviewPage extends StatefulWidget {
  final Session session;

  TermOverviewPage({super.key, required this.session});

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
    List<Term> terms = await server.term_list(widget.session);
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
          // three pages, choose user, users that should be active, users that should be inactive
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
