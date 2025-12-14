import 'package:cptclient/api/admin/club/term.dart' as api_admin;
import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TermCreatePage extends StatefulWidget {
  final UserSession session;
  final Club? club;
  final User? user;

  TermCreatePage({
    super.key,
    required this.session,
    this.club,
    this.user,
  });

  @override
  TermCreatePageState createState() => TermCreatePageState();
}

class TermCreatePageState extends State<TermCreatePage> {
  final FieldController<Club> _ctrlTermClub = FieldController<Club>();
  final FieldController<User> _ctrlTermUser = FieldController<User>();

  final DateTimeController _ctrlTermBegin = DateTimeController();
  final DateTimeController _ctrlTermEnd = DateTimeController();

  TermCreatePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    _ctrlTermUser.callItems = () => api_regular.user_list(widget.session);
    _ctrlTermClub.callItems = () => api_anon.club_list();
  }

  void _submit() async {
    if (widget.club == null && _ctrlTermClub.value == null) {
      messageText("${AppLocalizations.of(context)!.termClub} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlTermUser.value == null) {
      messageText("${AppLocalizations.of(context)!.termUser} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Term term = Term(
      club: widget.club ?? _ctrlTermClub.value,
      user: widget.user ?? _ctrlTermUser.value,
      begin: _ctrlTermBegin.getDateTime(),
      end: _ctrlTermEnd.getDateTime(),
    );

    var result = await api_admin.term_create(widget.session, term);
    if (result is! Success) return;

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
          if (widget.user == null)
            AppInfoRow(
              info: AppLocalizations.of(context)!.termUser,
              child: AppField<User>(
                controller: _ctrlTermUser,
                onChanged: (user) => setState(() => _ctrlTermUser.value = user),
              ),
            ),
          if (widget.club == null)
            AppInfoRow(
              info: AppLocalizations.of(context)!.termClub,
              child: AppField<Club>(
                controller: _ctrlTermClub,
                onChanged: (club) => setState(() => _ctrlTermClub.value = club),
              ),
            ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termBegin,
            child: DateTimeField(
              nullable: true,
              showTime: false,
              controller: _ctrlTermBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termEnd,
            child: DateTimeField(
              nullable: true,
              showTime: false,
              controller: _ctrlTermEnd,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
