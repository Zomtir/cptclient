import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/dialogs/AppPicker.dart';
import 'package:cptclient/material/dialogs/UserPicker.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/material/tiles/AppTermTile.dart';
import 'package:cptclient/static/server_term_admin.dart' as server;
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermEditPage extends StatefulWidget {
  final Session session;
  final Term term;
  final void Function() onUpdate;
  final bool isDraft;

  TermEditPage({super.key, required this.session, required this.term, required this.onUpdate, required this.isDraft});

  @override
  TermEditPageState createState() => TermEditPageState();
}

class TermEditPageState extends State<TermEditPage> {
  User? _ctrlTermUser;
  Club? _ctrlTermClub;
  final DateTimeController _ctrlTermBegin = DateTimeController();
  final DateTimeController _ctrlTermEnd = DateTimeController();

  TermEditPageState();

  @override
  void initState() {
    super.initState();
    _applyTerm();
  }

  void _applyTerm() {
    _ctrlTermUser = widget.term.user;
    _ctrlTermClub = widget.term.club;
    _ctrlTermBegin.setDateTime(widget.term.begin);
    _ctrlTermEnd.setDateTime(widget.term.end);
  }

  void _gatherTerm() {
    widget.term.user = _ctrlTermUser;
    widget.term.club = _ctrlTermClub;
    widget.term.begin = _ctrlTermBegin.getDateTime();
    widget.term.end = _ctrlTermEnd.getDateTime();
  }

  void _submitTerm() async {
    _gatherTerm();

    if (_ctrlTermUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.termUser} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (_ctrlTermClub == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.termClub} ${AppLocalizations.of(context)!.isInvalid}")));
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

  void _handleUserSearch(BuildContext context) async {
    List<User> users = await server.user_list(widget.session);

    User? user = await showAppUserPicker(context: context, users: users, initialUser: _ctrlTermUser);

    setState(() {
      _ctrlTermUser = user;
    });
  }

  void _handleUserClear() {
    setState(() {
      _ctrlTermUser = null;
    });
  }

  void _handleClubSearch(BuildContext context) async {
    List<Club> clubs = []; //FIXME: await server.club_list(widget.session);

    Club? club = await showAppPicker<Club>(
      context: context,
      items: clubs,
      initial: _ctrlTermClub,
      builder: (Club club) => AppClubTile(club: club),
      filter: filterClubs,
    );

    setState(() {
      _ctrlTermClub = club;
    });
  }

  void _handleClubClear() {
    setState(() {
      _ctrlTermClub = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTermEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            Row(
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
          if (!widget.isDraft) Divider(),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termUser),
            child: Text(_ctrlTermUser == null ? AppLocalizations.of(context)!.undefined : "[${_ctrlTermUser!.key}] ${_ctrlTermUser!.firstname} ${_ctrlTermUser!.lastname}"),
            trailing: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _handleUserSearch(context),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _handleUserClear,
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termClub),
            child: Text(_ctrlTermClub?.name ?? AppLocalizations.of(context)!.undefined),
            trailing: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _handleClubSearch(context),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _handleClubClear,
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termBegin),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlTermBegin,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.termEnd),
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
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
