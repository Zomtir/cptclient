import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class OrganisationCreatePage extends StatefulWidget {
  final UserSession session;

  OrganisationCreatePage({super.key, required this.session});

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
    Organisation organisation = Organisation.fromVoid();
    _ctrlAbbreviation.text = organisation.abbreviation;
    _ctrlName.text = organisation.name;
  }

  void _handleSubmit() async {
    if (_ctrlAbbreviation.text.isEmpty) {
      messageText(
        "${AppLocalizations.of(context)!.organisationAbbreviation} ${AppLocalizations.of(context)!.statusIsInvalid}",
      );
      return;
    }

    if (_ctrlName.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.organisationName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Organisation organisation = Organisation(
      abbreviation: _ctrlAbbreviation.text,
      name: _ctrlName.text,
    );

    var result = await api_admin.organisation_create(widget.session, organisation);
    if (result is! Success) return;

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
