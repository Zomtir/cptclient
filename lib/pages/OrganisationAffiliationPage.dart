import 'package:cptclient/api/admin/organisation/affiliation.dart' as api_admin;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/AffiliationEditPage.dart';
import 'package:flutter/material.dart';

class OrganisationAffiliationPage extends StatefulWidget {
  final UserSession session;
  final Organisation organisation;

  OrganisationAffiliationPage({super.key, required this.session, required this.organisation});

  @override
  State<StatefulWidget> createState() => OrganisationAffiliationPageState();
}

class OrganisationAffiliationPageState extends State<OrganisationAffiliationPage> {
  GlobalKey<SearchablePanelState<Affiliation>> searchPanelKey = GlobalKey();

  OrganisationAffiliationPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Affiliation> affiliations = await api_admin.affiliation_list(widget.session, null, widget.organisation);
    searchPanelKey.currentState?.update(affiliations);
  }

  Future<void> _handleSelect(Affiliation affiliation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AffiliationEditPage(
          session: widget.session,
          affiliation: affiliation,
        ),
      ),
    );

    _update();
  }

  Future<void> _handleCreate() async {
    List<User> users = await api_regular.user_list(widget.session);
    User? user;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(items: users, onPick: (item) => user = item),
    );

    if (user == null) return;

    await api_admin.affiliation_create(widget.session, user!, widget.organisation);
    Affiliation affiliation = Affiliation.fromNew(user, widget.organisation);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AffiliationEditPage(
          session: widget.session,
          affiliation: affiliation,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageAffiliationManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel<Affiliation>(
            key: searchPanelKey,
            onTap: _handleSelect,
          ),
        ],
      ),
    );
  }
}
