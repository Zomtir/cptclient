import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/OrganisationEditPage.dart';
import 'package:flutter/material.dart';

class OrganisationOverviewPage extends StatefulWidget {
  final UserSession session;

  OrganisationOverviewPage({super.key, required this.session});

  @override
  OrganisationOverviewPageState createState() => OrganisationOverviewPageState();
}

class OrganisationOverviewPageState extends State<OrganisationOverviewPage> {
  GlobalKey<SearchablePanelState<Organisation>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Organisation> organisations = await api_admin.organisation_list(widget.session);
    searchPanelKey.currentState?.setItems(organisations);
  }

  void _handleSelect(Organisation organisation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganisationEditPage(
          session: widget.session,
          organisation: organisation,
          isDraft: false,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganisationEditPage(
          session: widget.session,
          organisation: Organisation.fromVoid(),
          isDraft: true,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageOrganisationManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          SearchablePanel(
            key: searchPanelKey,
            builder: (Organisation organisation, Function(Organisation)? onSelect) => InkWell(
              onTap: () => onSelect?.call(organisation),
              child: organisation.buildTile(context),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
