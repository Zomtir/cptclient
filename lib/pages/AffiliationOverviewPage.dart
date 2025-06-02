import 'package:cptclient/api/admin/organisation/affiliation.dart' as api_admin;
import 'package:cptclient/api/admin/organisation/organisation.dart' as api_admin;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/fields/AppField.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/tiles/AppAffiliationTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/FilterToggle.dart';
import 'package:cptclient/pages/AffiliationEditPage.dart';
import 'package:flutter/material.dart';

class AffiliationOverviewPage extends StatefulWidget {
  final UserSession session;
  final User? user;
  final Organisation? organisation;

  AffiliationOverviewPage({super.key, required this.session, this.user, this.organisation});

  @override
  State<StatefulWidget> createState() => AffiliationOverviewPageState();
}

class AffiliationOverviewPageState extends State<AffiliationOverviewPage> {
  List<Affiliation> _affiliations = [];

  final FieldController<User> _ctrlUser = FieldController();
  final FieldController<Organisation> _ctrlOrganisation = FieldController();

  AffiliationOverviewPageState();

  @override
  void initState() {
    super.initState();

    _ctrlUser.callItems = () => api_regular.user_list(widget.session);
    _ctrlOrganisation.callItems = () => api_admin.organisation_list(widget.session);

    _update();
  }

  Future<void> _update() async {
    List<Affiliation> affiliations = await api_admin.affiliation_list(
        widget.session, _ctrlUser.value, _ctrlOrganisation.value);

    setState(() => _affiliations = affiliations);
  }

  Future<void> _handleSelect(Affiliation affiliation, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AffiliationEditPage(
              session: widget.session,
              affiliation: affiliation,
            ),
      ),
    );

    _update();
  }

  Future<void> _handleCreate() async {
    User? user = widget.user;
    if (user == null) {
      List<User> users = await api_regular.user_list(widget.session);
      user = await showTilePicker(context: context, items: users);

      if (user == null) return;
    }

    Organisation? organisation = widget.organisation;
    if (organisation == null) {
      List<Organisation> organisations = await api_admin.organisation_list(widget.session);
      organisation = await showTilePicker(context: context, items: organisations);

      if (organisation == null) return;
    }

    await api_admin.affiliation_create(widget.session, user, organisation);
    Affiliation affiliation = Affiliation.fromNew(user, organisation);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AffiliationEditPage(
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
      ),
      body: AppBody(
        children: <Widget>[
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.user,
                child: AppField<User>(
                  controller: _ctrlUser,
                  onChanged: (User? user) =>
                      setState(() => _ctrlUser.value = user),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.organisation,
                child: AppField<Organisation>(
                  controller: _ctrlOrganisation,
                  onChanged: (Organisation? organisation) =>
                      setState(() => _ctrlOrganisation.value = organisation),
                ),
              ),
            ],
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          AppListView<Affiliation>(
            items: _affiliations,
            itemBuilder: (Affiliation affiliation) {
              return InkWell(
                onTap: () => _handleSelect(affiliation, false),
                child: AppAffiliationTile(
                  affiliation: affiliation,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
