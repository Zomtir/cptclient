import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppTermTile.dart';

import '../json/user.dart';
import '../material/AppDropdown.dart';
import '../material/DropdownController.dart';
import '../static/serverTermAdmin.dart' as server;
import '../static/serverUserMember.dart' as server;
import '../json/session.dart';
import '../json/term.dart';

class TermEditPage extends StatefulWidget {
  final Session session;
  final Term term;
  final void Function() onUpdate;
  final bool isDraft;

  TermEditPage({Key? key, required this.session, required this.term, required this.onUpdate, required this.isDraft}) : super(key: key);

  @override
  TermEditPageState createState() => TermEditPageState();
}

class TermEditPageState extends State<TermEditPage> {
  DropdownController<User> _ctrlTermUser = DropdownController<User>(items: []);
  DateTimeController       _ctrlTermBegin = DateTimeController();
  DateTimeController       _ctrlTermEnd = DateTimeController();

  TermEditPageState();

  @override
  void initState() {
    super.initState();
    _getMembers();
    _applyTerm();
  }

  Future<void> _getMembers() async {
    List<User> users = await server.user_list(widget.session);

    setState(() {
      _ctrlTermUser.items = users;
    });
  }

  void _applyTerm() {
    _ctrlTermUser.value = widget.term.user;
    _ctrlTermBegin.setDateTime(widget.term.begin);
    _ctrlTermEnd.setDateTime(widget.term.end);
  }

  void _gatherTerm() {
    widget.term.user = _ctrlTermUser.value;
    widget.term.begin = _ctrlTermBegin.getDateTime();
    widget.term.end = _ctrlTermEnd.getDateTime();
  }

  void _submitTerm() async {
    _gatherTerm();

    if (_ctrlTermUser.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.termUser} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft ? await server.term_create(widget.session, widget.term) : await server.term_edit(widget.session, widget.term);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteTerm() async {
    if (!await server.term_delete(widget.session, widget.term)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.deletionFail)));
      return;
    }

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTermEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) Row(
            children: [
              Expanded(
                child: AppTermTile(
                  term: widget.term,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteTerm,
              ),
            ],
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termUser),
            child: AppDropdown<User>(
              hint: Text(AppLocalizations.of(context)!.actionSelect),
              controller: _ctrlTermUser,
              builder: (User user) {
                return Text("[${user.key}] ${user.firstname} ${user.lastname}");
              },
              onChanged: (User? user) {
                setState(() {
                  _ctrlTermUser.value = user;
                });
              },
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termBegin),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlTermBegin,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termEnd),
            child: DateTimeEdit(
              nullable: true,
              dateOnly: true,
              controller: _ctrlTermEnd,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submitTerm,
          ),
        ],
      ),
    );
  }
}
