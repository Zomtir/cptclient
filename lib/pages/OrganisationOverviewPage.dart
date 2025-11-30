import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/OrganisationCreatePage.dart';
import 'package:cptclient/pages/OrganisationDetailPage.dart';
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
    searchPanelKey.currentState?.populate(organisations);
  }

  void _handleSelect(Organisation organisation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganisationDetailPage(
          session: widget.session,
          organisation: organisation,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganisationCreatePage(
          session: widget.session,
          organisation: Organisation.fromVoid(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel(
            key: searchPanelKey,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
