import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/CategoryEdit.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ClubCreatePage extends StatefulWidget {
  final UserSession session;

  ClubCreatePage({super.key, required this.session});

  @override
  ClubCreatePageState createState() => ClubCreatePageState();
}

class ClubCreatePageState extends State<ClubCreatePage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlDescription = TextEditingController();
  String? _ctrlDisciplines;
  final TextEditingController _ctrlImageURL = TextEditingController();
  final TextEditingController _ctrlChairman = TextEditingController();

  ClubCreatePageState();

  void _handleSubmit() async {
    if (_ctrlKey.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.clubKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlName.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.clubName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Club club = Club.fromVoid();
    club.key = _ctrlKey.text;
    club.name = _ctrlName.text;
    club.description = _ctrlDescription.text.isNotEmpty ? _ctrlDescription.text : null;
    club.disciplines = _ctrlDisciplines!.isNotEmpty ? _ctrlDisciplines! : null;
    club.image_url = _ctrlImageURL.text.isNotEmpty ? _ctrlImageURL.text : null;
    club.chairman = _ctrlChairman.text.isNotEmpty ? _ctrlChairman.text : null;

    var result = await api_admin.club_create(widget.session, club);

    if (result is! Success) return;

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
            child: CategoryEdit(
              text: _ctrlDisciplines!,
              onChanged: (text) => _ctrlDisciplines = text,
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
