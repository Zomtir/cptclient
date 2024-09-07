import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppOrganisationTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrganisationEditPage extends StatefulWidget {
  final UserSession session;
  final Organisation organisation;
  final bool isDraft;

  OrganisationEditPage(
      {super.key, required this.session, required this.organisation, required this.isDraft});

  @override
  OrganisationEditPageState createState() => OrganisationEditPageState();
}

class OrganisationEditPageState extends State<OrganisationEditPage> {
  final TextEditingController _ctrlAbbreviation = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();

  OrganisationEditPageState();

  @override
  void initState() {
    super.initState();
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlAbbreviation.text = widget.organisation.abbreviation;
    _ctrlName.text = widget.organisation.name;
  }

  void _gatherInfo() {
    widget.organisation.abbreviation = _ctrlAbbreviation.text;
    widget.organisation.name = _ctrlName.text;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.organisation.abbreviation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.organisationAbbreviation} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.organisation.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.organisationName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.organisation_create(widget.session, widget.organisation)
        : await api_admin.organisation_edit(widget.session, widget.organisation);

    if (!success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.organisation_delete(widget.session, widget.organisation)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageOrganisationEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppOrganisationTile(
              organisation: widget.organisation,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _handleDelete,
                ),
              ],
            ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.organisationAbbreviation,
            child: TextField(
              maxLines: 1,
              controller: _ctrlAbbreviation,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.organisationName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
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
