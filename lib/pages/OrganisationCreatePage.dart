import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class OrganisationCreatePage extends StatefulWidget {
  final UserSession session;
  final Organisation organisation;

  OrganisationCreatePage({super.key, required this.session, required this.organisation});

  @override
  OrganisationCreatePageState createState() => OrganisationCreatePageState();
}

class OrganisationCreatePageState extends State<OrganisationCreatePage> {
  final TextEditingController _ctrlAbbreviation = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();

  OrganisationCreatePageState();

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
      messageText("${AppLocalizations.of(context)!.organisationAbbreviation} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (widget.organisation.name.isEmpty) {
      messageText("${AppLocalizations.of(context)!.organisationName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    bool success = await api_admin.organisation_create(widget.session, widget.organisation);

    if (!success) return;

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
