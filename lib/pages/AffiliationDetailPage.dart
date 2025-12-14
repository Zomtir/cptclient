import 'package:cptclient/api/admin/organisation/affiliation.dart' as api_admin;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class AffiliationDetailPage extends StatefulWidget {
  final UserSession session;
  final Affiliation affiliation;

  AffiliationDetailPage({super.key, required this.session, required this.affiliation});

  @override
  State<StatefulWidget> createState() => AffiliationDetailPageState();
}

class AffiliationDetailPageState extends State<AffiliationDetailPage> {

  AffiliationDetailPageState();

  void _submit() async {
    final result = await api_admin.affiliation_edit(widget.session, widget.affiliation);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  void _handleDelete() async {
    var result = await api_admin.affiliation_delete(widget.session, widget.affiliation);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageAffiliationEdit),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.organisation,
            child: widget.affiliation.organisation!.buildInfo(context),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.user,
            child: widget.affiliation.user!.buildInfo(context),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.affiliationMemberIdentifier}",
            child: ListTile(
              title: Text(widget.affiliation.member_identifier ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(widget.affiliation.member_identifier ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => TextEditDialog(
                        initialValue: widget.affiliation.member_identifier ?? '',
                        minLength: 1,
                        maxLength: 10,
                        onConfirm: (String text) {
                          setState(() => widget.affiliation.member_identifier = text);
                          _submit();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationPermissionSoloDate,
            child: ListTile(
              title: Text(widget.affiliation.permission_solo_date?.fmtDate(context) ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(formatIsoDate(widget.affiliation.permission_solo_date) ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DatePicker(
                        initialDate: widget.affiliation.permission_solo_date,
                        onConfirm: (DateTime? dt) {
                          setState(() => widget.affiliation.permission_solo_date = dt);
                          _submit();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationPermissionTeamDate,
            child: ListTile(
              title: Text(widget.affiliation.permission_team_date?.fmtDate(context) ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(formatIsoDate(widget.affiliation.permission_team_date) ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DatePicker(
                        initialDate: widget.affiliation.permission_team_date,
                        onConfirm: (DateTime? dt) {
                          setState(() => widget.affiliation.permission_team_date = dt);
                          _submit();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationResidencyMoveDate,
            child: ListTile(
              title: Text(widget.affiliation.residency_move_date?.fmtDate(context) ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(formatIsoDate(widget.affiliation.residency_move_date) ?? ''),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DatePicker(
                        initialDate: widget.affiliation.residency_move_date,
                        onConfirm: (DateTime? dt) {
                          setState(() => widget.affiliation.residency_move_date = dt);
                          _submit();
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
