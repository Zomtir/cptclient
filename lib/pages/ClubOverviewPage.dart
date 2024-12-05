import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/ClubDetailPage.dart';
import 'package:cptclient/pages/ClubEditPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubOverviewPage extends StatefulWidget {
  final UserSession session;

  ClubOverviewPage({super.key, required this.session});

  @override
  ClubOverviewPageState createState() => ClubOverviewPageState();
}

class ClubOverviewPageState extends State<ClubOverviewPage> {
  GlobalKey<SearchablePanelState<Club>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Club> clubs = await api_admin.club_list(widget.session);
    searchPanelKey.currentState?.setItems(clubs);
  }

  void _handleSelect(Club club) async {
    Club? club_info = await api_admin.club_info(widget.session, club);

    if (club_info == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubDetailPage(
          session: widget.session,
          club: club_info,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubEditPage(
          session: widget.session,
          club: Club.fromVoid(),
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
        title: Text(AppLocalizations.of(context)!.pageClubManagement),
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
            builder: (Club club, Function(Club)? onSelect) => InkWell(
              onTap: () => onSelect?.call(club),
              child: club.buildTile(),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
