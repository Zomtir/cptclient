import 'package:cptclient/api/admin/club/term.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
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
  Term? term;

  TermDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    _locked = true;
    var result = await api_admin.term_info(widget.session, widget.termID);
    if (result is! Success) return;
    setState(() => term = result.unwrap());
    _locked = false;
  }

  void submit() async {
    await api_admin.term_edit(widget.session, term!);
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
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.termUser,
            child: term!.user!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termClub,
            child: term!.club!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termBegin,
            child: AppTile(
              child: Text(term!.begin?.fmtDate(context) ?? AppLocalizations.of(context)!.labelUnknown),
              trailing: [
                IconButton(
                  onPressed: () => clipText(formatIsoDate(term!.begin) ?? ''),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DatePicker(
                      initialDate: term!.begin,
                      onConfirm: (DateTime dt) {
                        setState(() => term!.begin = dt);
                        submit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.termEnd,
            child: AppTile(
              child: Text(term!.end?.fmtDate(context) ?? AppLocalizations.of(context)!.labelOngoing),
              trailing: [
                IconButton(
                  onPressed: () => clipText(formatIsoDate(term!.end) ?? ''),
                  icon: Icon(Icons.copy),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DatePicker(
                      initialDate: term!.end,
                      onConfirm: (DateTime dt) {
                        setState(() => term!.end = dt);
                        submit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
