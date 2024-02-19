import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppTermTile.dart';
import 'package:cptclient/pages/TermEditPage.dart';
import 'package:cptclient/static/server_term_admin.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermManagementPage extends StatefulWidget {
  final Session session;

  TermManagementPage({super.key, required this.session});

  @override
  TermManagementPageState createState() => TermManagementPageState();
}

class TermManagementPageState extends State<TermManagementPage> {
  List<Term> _terms = [];

  TermManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Term> terms = await server.term_list(widget.session);
    setState(() {
      _terms = terms;
    });
  }

  void _selectTerm(Term term) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermEditPage(
          session: widget.session,
          term: term,
          onUpdate: _update,
          isDraft: false,
        ),
      ),
    );
  }

  void _createTerm() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermEditPage(
          session: widget.session,
          term: Term.fromVoid(),
          onUpdate: _update,
          isDraft: true,
        ),
      ),
    );
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
          AppListView(
            items: _terms,
            itemBuilder: (Term term) {
              return InkWell(
                onTap: () => _selectTerm(term),
                child: AppTermTile(
                  term: term,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
