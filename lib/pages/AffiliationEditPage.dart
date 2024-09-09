import 'package:cptclient/api/admin/organisation/affiliation.dart' as api_admin;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppAffiliationTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AffiliationEditPage extends StatefulWidget {
  final UserSession session;
  final Affiliation affiliation;

  AffiliationEditPage({super.key, required this.session, required this.affiliation});

  @override
  State<StatefulWidget> createState() => AffiliationEditPageState();
}

class AffiliationEditPageState extends State<AffiliationEditPage> {
  final TextEditingController _ctrlMemberIdentifier = TextEditingController();
  final DateTimeController _ctrlPermissionSolo = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlPermissionTeam = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlResidencyMove = DateTimeController(dateTime: DateTime.now());

  AffiliationEditPageState();

  @override
  void initState() {
    super.initState();
    _apply();
  }

  void _apply() {
    _ctrlMemberIdentifier.text = widget.affiliation.member_identifier ?? "";
    _ctrlPermissionSolo.setDateTime(widget.affiliation.permission_solo_date);
    _ctrlPermissionTeam.setDateTime(widget.affiliation.permission_team_date);
    _ctrlResidencyMove.setDateTime(widget.affiliation.residency_move_date);
  }

  void _gather() {
    widget.affiliation.member_identifier = _ctrlMemberIdentifier.text;
    widget.affiliation.permission_solo_date = _ctrlPermissionSolo.getDateTime();
    widget.affiliation.permission_team_date = _ctrlPermissionTeam.getDateTime();
    widget.affiliation.residency_move_date = _ctrlResidencyMove.getDateTime();
  }

  void _handleSubmit() async {
    _gather();

    final success = await api_admin.affiliation_edit(widget.session, widget.affiliation);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully saved ranking')));
    Navigator.pop(context);
  }

  void _handleDelete() async {
    final success = await api_admin.affiliation_delete(widget.session, widget.affiliation);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ranking')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted ranking')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageAffiliationEdit),
      ),
      body: AppBody(
        children: [
          Row(
            children: [
              Expanded(
                child: AppAffiliationTile(
                  affiliation: widget.affiliation,
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _handleDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.affiliationMemberIdentifier}",
            child: TextField(
              maxLines: 1,
              controller: _ctrlMemberIdentifier,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationPermissionSoloDate,
            child: DateTimeEdit(
              controller: _ctrlPermissionSolo,
              showTime: false,
              nullable: true,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationPermissionTeamDate,
            child: DateTimeEdit(
              controller: _ctrlPermissionTeam,
              showTime: false,
              nullable: true,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.affiliationResidencyMoveDate,
            child: DateTimeEdit(
              controller: _ctrlResidencyMove,
              showTime: false,
              nullable: true,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
