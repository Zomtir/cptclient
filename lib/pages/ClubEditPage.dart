import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubEditPage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final bool isDraft;

  ClubEditPage(
      {super.key,
      required this.session,
      required this.club,
      required this.isDraft});

  @override
  ClubEditPageState createState() => ClubEditPageState();
}

class ClubEditPageState extends State<ClubEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();
  final TextEditingController _ctrlDisciplines = TextEditingController();
  final TextEditingController _ctrlImageURL = TextEditingController();
  final TextEditingController _ctrlChairman = TextEditingController();

  ClubEditPageState();

  @override
  void initState() {
    super.initState();
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlKey.text = widget.club.key;
    _ctrlName.text = widget.club.name;
    _ctrlDescription.text = widget.club.description ?? '';
    _ctrlDisciplines.text = widget.club.disciplines ?? '';
    _ctrlImageURL.text = widget.club.image_url ?? '';
    _ctrlChairman.text = widget.club.chairman ?? '';
  }

  void _gatherInfo() {
    widget.club.key = _ctrlKey.text;
    widget.club.name = _ctrlName.text;
    widget.club.description = _ctrlDescription.text.isNotEmpty ? _ctrlDescription.text : null;
    widget.club.disciplines = _ctrlDisciplines.text.isNotEmpty ? _ctrlDisciplines.text : null;
    widget.club.image_url = _ctrlImageURL.text.isNotEmpty ? _ctrlImageURL.text : null;
    widget.club.chairman = _ctrlChairman.text.isNotEmpty ? _ctrlChairman.text : null;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.club.key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.clubKey} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.club.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.clubName} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.club_create(widget.session, widget.club)
        : await api_admin.club_edit(widget.session, widget.club);

    if (!success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubEdit),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            AppClubTile(club: widget.club),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubName,
            child: TextField(
              maxLines: 1,
              controller: _ctrlName,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubDescription,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDescription,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubDisciplines,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDisciplines,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubImageURL,
            child: TextField(
              maxLines: 1,
              controller: _ctrlImageURL,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubChairman,
            child: TextField(
              maxLines: 1,
              controller: _ctrlChairman,
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
