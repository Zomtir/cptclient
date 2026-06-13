import 'package:cptclient/api/admin/club/term.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/DateEditDialog.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TermDetailPage extends StatefulWidget {
  final UserSession session;
  final int termID;

  TermDetailPage({
    super.key,
    required this.session,
    required this.termID,
  });

  @override
  TermDetailPageState createState() => TermDetailPageState();
}

class TermDetailPageState extends State<TermDetailPage> {
  bool _locked = true;
  Term? _term;

  TermDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    setState(() => _locked = true);
    var result = await api_admin.term_info(widget.session, widget.termID);
    if (result is! Success) return;
    setState(() {
      _term = result.unwrap();
      _locked = false;
    });
  }

  void submit() async {
    await api_admin.term_edit(widget.session, _term!);
    update();
  }

  void _deleteTerm() async {
    var result = await api_admin.term_delete(widget.session, widget.termID);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageTermEdit),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTerm,
          ),
        ],
      ),
      body: AppBody(
        locked: _locked,
        builder: (context) => [
          AppInfoRow(
            info: AppLocalizations.of(context)!.termUser,
            child: _term!.user!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termClub,
            child: _term!.club!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termBegin,
            child: Text(_term!.begin?.fmtDate(context) ?? AppLocalizations.of(context)!.labelUnknown),
            actions: [
              IconButton(
                onPressed: () => clipText(formatIsoDate(_term!.begin) ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DateEditDialog(
                    initialDate: _term!.begin,
                    onConfirm: (DateTime dt) {
                      setState(() => _term!.begin = dt);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termEnd,
            child: Text(_term!.end?.fmtDate(context) ?? AppLocalizations.of(context)!.labelOngoing),
            actions: [
              IconButton(
                onPressed: () => clipText(formatIsoDate(_term!.end) ?? ''),
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DateEditDialog(
                    initialDate: _term!.end,
                    onConfirm: (DateTime dt) {
                      setState(() => _term!.end = dt);
                      submit();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
