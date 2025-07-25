import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/TextEdit.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/pages/OrganisationAffiliationPage.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class OrganisationDetailPage extends StatefulWidget {
  final UserSession session;
  final Organisation organisation;

  OrganisationDetailPage(
      {super.key, required this.session, required this.organisation});

  @override
  OrganisationDetailPageState createState() => OrganisationDetailPageState();
}

class OrganisationDetailPageState extends State<OrganisationDetailPage> {
  OrganisationDetailPageState();

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() async {
    if (widget.organisation.abbreviation.isEmpty) {
      messageText("${AppLocalizations.of(context)!.organisationAbbreviation} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (widget.organisation.name.isEmpty) {
      messageText("${AppLocalizations.of(context)!.organisationName} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    bool success = await api_admin.organisation_edit(widget.session, widget.organisation);
    messageFailureOnly(success);
  }

  void _handleDelete() async {
    if (!await api_admin.organisation_delete(widget.session, widget.organisation)) return;

    Navigator.pop(context);
  }

  void _handleAffiliations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrganisationAffiliationPage(session: widget.session, organisation: widget.organisation)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageOrganisationEdit),
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
            info: "${AppLocalizations.of(context)!.organisationAbbreviation}",
            child: ListTile(
              title: Text(widget.organisation.abbreviation),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(widget.organisation.abbreviation),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: widget.organisation.abbreviation,
                        minLength: 1,
                        maxLength: 10,
                        nullable: false,
                      ),
                      onChanged: (String text) {
                        setState(() => widget.organisation.abbreviation = text);
                        _handleSubmit();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.organisationName}",
            child: ListTile(
              title: Text(widget.organisation.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(widget.organisation.name),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: widget.organisation.name,
                        minLength: 1,
                        maxLength: 30,
                        nullable: false,
                      ),
                      onChanged: (String text) {
                        setState(() => widget.organisation.name = text);
                        _handleSubmit();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageAffiliationManagement),
                onTap: _handleAffiliations,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
