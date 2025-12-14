import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/api/anon/organisation.dart' as api_anon;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/CategoryEditDialog.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/dialogs/TextEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/widgets/CategoryDisplay.dart';
import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:cptclient/material/widgets/SectionToggle.dart';
import 'package:cptclient/pages/ClubStatisticMemberPage.dart';
import 'package:cptclient/pages/ClubStatisticOrganisationPage.dart';
import 'package:cptclient/pages/ClubStatisticPresencePage.dart';
import 'package:cptclient/pages/ClubStatisticTeamPage.dart';
import 'package:cptclient/pages/ClubTermOverviewPage.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ClubDetailPage extends StatefulWidget {
  final UserSession session;
  final int clubID;

  ClubDetailPage({super.key, required this.session, required this.clubID});

  @override
  ClubDetailPageState createState() => ClubDetailPageState();
}

class ClubDetailPageState extends State<ClubDetailPage> {
  bool _locked = true;
  Club? club;

  ClubDetailPageState();

  @override
  void initState() {
    super.initState();
    update();
  }

  void update() async {
    _locked = true;
    var result = await api_admin.club_info(widget.session, widget.clubID);
    if (result is! Success) return;
    setState(() => club = result.unwrap());
    _locked = false;
  }

  void submit() async {
    await api_admin.club_edit(widget.session, club!);
    update();
  }

  void _handleDelete() async {
    var result = await api_admin.club_delete(widget.session, widget.clubID);
    if (result is! Success) return;
    Navigator.pop(context);
  }

  Future<void> _handleTerms() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubTermOverviewPage(
          session: widget.session,
          club: club!,
        ),
      ),
    );
  }

  Future<void> _handleStatisticMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticMemberPage(
          session: widget.session,
          club: club!,
        ),
      ),
    );
  }

  Future<void> _handleStatisticTeams() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticTeamPage(
          session: widget.session,
          club: club!,
        ),
      ),
    );
  }

  Future<void> _handleStatisticPresence() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticPresencePage(
          session: widget.session,
          club: club!,
          userID: widget.session.user!.id,
          title:
              '${AppLocalizations.of(context)!.pageClubStatisticPresence} - ${AppLocalizations.of(context)!.eventLeader}',
        ),
      ),
    );
  }

  Future<void> _handleStatisticOrganisation() async {
    var result_organisations = await api_anon.organisation_list();
    if (result_organisations is! Success) return;
    Organisation? organisation;

    await showDialog(
      context: context,
      builder: (context) => PickerDialog(
        items: result_organisations.unwrap(),
        onPick: (item) => organisation = item,
      ),
    );

    if (organisation == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubStatisticOrganisationPage(
          session: widget.session,
          club: club!,
          organisation: organisation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) return LoadingWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SectionToggle(
          title: AppLocalizations.of(context)!.labelMoreDetails,
          children: [
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubKey,
              child: ListTile(
                title: Text(club!.key),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.key),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.key,
                          minLength: 1,
                          maxLength: 10,
                          onConfirm: (String t) {
                            setState(() => club!.key = t);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubName,
              child: ListTile(
                title: Text(club!.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.name),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.name,
                          minLength: 1,
                          maxLength: 30,
                          onConfirm: (String t) {
                            setState(() => club!.name = t);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubDescription,
              child: ListTile(
                title: Text(club!.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.description ?? ''),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.description ?? '',
                          maxLines: 5,
                          minLength: 0,
                          maxLength: 100,
                          onConfirm: (String t) {
                            setState(() => club!.description = t);
                            submit();
                          },
                          onReset: () {
                            setState(() => club!.description = null);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubDisciplines,
              child: ListTile(
                title: CategoryDisplay(text: club!.disciplines ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.disciplines ?? ''),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => CategoryEditDialog(
                          initialValue: club!.disciplines ?? '',
                          maxLength: 500,
                          onConfirm: (String t) {
                            setState(() => club!.disciplines = t);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubImageURL,
              child: ListTile(
                title: Text(club!.image_url ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.image_url ?? ''),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.image_url ?? '',
                          minLength: 0,
                          maxLength: 50,
                          onConfirm: (String t) {
                            setState(() => club!.image_url = t);
                            submit();
                          },
                          onReset: () {
                            setState(() => club!.image_url = null);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubBannerURL,
              child: ListTile(
                title: Text(club!.banner_url ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.banner_url ?? ''),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.banner_url ?? '',
                          minLength: 0,
                          maxLength: 50,
                          onConfirm: (String t) {
                            setState(() => club!.banner_url = t);
                            submit();
                          },
                          onReset: () {
                            setState(() => club!.banner_url = null);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppInfoRow(
              info: AppLocalizations.of(context)!.clubChairman,
              child: ListTile(
                title: Text(club!.chairman ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => clipText(club!.chairman ?? ''),
                      icon: Icon(Icons.copy),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => TextEditDialog(
                          initialValue: club!.chairman ?? '',
                          minLength: 0,
                          maxLength: 50,
                          onConfirm: (String t) {
                            setState(() => club!.chairman = t);
                            submit();
                          },
                          onReset: () {
                            setState(() => club!.chairman = null);
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          MenuSection(
            title: AppLocalizations.of(context)!.term,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageTermManagement),
                onTap: _handleTerms,
              ),
            ],
          ),
          MenuSection(
            title: AppLocalizations.of(context)!.labelStatistics,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticMember),
                onTap: _handleStatisticMember,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticTeam),
                onTap: _handleStatisticTeams,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticPresence),
                onTap: _handleStatisticPresence,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageClubStatisticOrganisation),
                onTap: _handleStatisticOrganisation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
