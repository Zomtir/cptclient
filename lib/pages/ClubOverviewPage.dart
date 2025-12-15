import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/ClubCreatePage.dart';
import 'package:cptclient/pages/ClubDetailPage.dart';
import 'package:flutter/material.dart';

class ClubOverviewPage extends StatefulWidget {
  final UserSession session;

  ClubOverviewPage({super.key, required this.session});

  @override
  ClubOverviewPageState createState() => ClubOverviewPageState();
}

class ClubOverviewPageState extends State<ClubOverviewPage> {
  bool _locked = true;
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    update();
  }

  Future<void> update() async {
    setState(() => _locked = true);
    var result = await api_admin.club_list(widget.session);
    if (!mounted) return;
    setState(() => _clubs = result.unwrap());
    setState(() => _locked = false);
  }

  void _handleSelect(Club club) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubDetailPage(
          session: widget.session,
          clubID: club.id,
        ),
      ),
    );

    update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubCreatePage(
          session: widget.session,
        ),
      ),
    );

    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubManagement),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _handleCreate),
        ],
      ),
      body: AppBody(
        locked: _locked,
        children: <Widget>[
          SearchablePanel(
            items: _clubs,
            onTap: _handleSelect,
          ),
        ],
      ),
    );
  }
}
