import 'package:cptclient/api/admin/club/term.dart' as api_admin;
import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppTermTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermEditPage extends StatefulWidget {
  final UserSession session;
  final Term term;
  final bool isDraft;
  final Club? club;

  TermEditPage(
      {super.key,
      required this.session,
      required this.term,
      required this.isDraft,
      this.club});

  @override
  TermEditPageState createState() => TermEditPageState();
}

class TermEditPageState extends State<TermEditPage> {
  final FieldController<User> _ctrlTermUser = FieldController<User>();
  final FieldController<Club> _ctrlTermClub = FieldController<Club>();
  final DateTimeController _ctrlTermBegin = DateTimeController();
  final DateTimeController _ctrlTermEnd = DateTimeController();

  TermEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
    _applyTerm();
  }

  Future<void> _update() async {
    _ctrlTermUser.callItems = () => api_regular.user_list(widget.session);
    _ctrlTermClub.callItems = () => api_anon.club_list();
  }

  void _applyTerm() {
    _ctrlTermUser.value = widget.term.user;
    _ctrlTermClub.value = widget.term.club;
    _ctrlTermBegin.setDateTime(widget.term.begin);
    _ctrlTermEnd.setDateTime(widget.term.end);
  }

  void _gatherTerm() {
    widget.term.user = _ctrlTermUser.value;
    widget.term.club = widget.club ?? _ctrlTermClub.value;
    widget.term.begin = _ctrlTermBegin.getDateTime();
    widget.term.end = _ctrlTermEnd.getDateTime();
  }

  void _submitTerm() async {
    _gatherTerm();

    if (_ctrlTermUser.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.termUser} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.club == null && _ctrlTermClub.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.termClub} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.term_create(widget.session, widget.term)
        : await api_admin.term_edit(widget.session, widget.term);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
  }

  void _deleteTerm() async {
    if (!await api_admin.term_delete(widget.session, widget.term)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
      return;
    }

    Navigator.pop(context);
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
            AppTermTile(
              term: widget.term,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteTerm,
                ),
              ],
            ),
          if (!widget.isDraft) Divider(),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termUser,
            child: AppField<User>(
              controller: _ctrlTermUser,
              onChanged: (user) => setState(() => _ctrlTermUser.value = user),
            ),
          ),
          if (widget.club == null) AppInfoRow(
            info: AppLocalizations.of(context)!.termClub,
            child: AppField<Club>(
              controller: _ctrlTermClub,
              onChanged: (club) => setState(() => _ctrlTermClub.value = club),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termBegin,
            child: DateTimeEdit(
              nullable: true,
              showTime: false,
              controller: _ctrlTermBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termEnd,
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
