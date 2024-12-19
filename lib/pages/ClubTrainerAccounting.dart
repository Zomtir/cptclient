import 'package:cptclient/api/admin/club/club.dart' as api_admin;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppClubTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/trainer_accounting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClubTrainerAccounting extends StatefulWidget {
  final UserSession session;
  final Club club;

  ClubTrainerAccounting({super.key, required this.session, required this.club});

  @override
  ClubTrainerAccountingState createState() => ClubTrainerAccountingState();
}

class ClubTrainerAccountingState extends State<ClubTrainerAccounting> {
  final TextEditingController _ctrlDiscipline = TextEditingController();
  final DateTimeController _ctrlBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -183)));
  final DateTimeController _ctrlEnd = DateTimeController(dateTime: DateTime.now());

  List<Event> _eventList = [];
  User? _userInfo;

  ClubTrainerAccountingState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    List<Event>? eventList = await api_admin.club_statistic_presence(widget.session, widget.club.id,
        widget.session.user!.id, DateTime(2024,7,1), DateTime(2024,12,31), "leader");
    if (eventList == null) return;
    eventList.sort();
    User? userInfo = await api_regular.user_info(widget.session);
    if (userInfo == null) return;

    setState(() {
      _eventList = eventList;
      _userInfo = userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageClubEdit),
      ),
      body: AppBody(
        children: [
          AppClubTile(club: widget.club),
          AppUserTile(user: widget.session.user!),
          AppInfoRow(
            info: AppLocalizations.of(context)!.clubKey,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDiscipline,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventBegin,
            child: DateTimeEdit(
              controller: _ctrlBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventEnd,
            child: DateTimeEdit(
              controller: _ctrlEnd,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionConfirm,
            // fix snapshotting
            onPressed: () => trainer_accounting_pdf(context, widget.club, _userInfo!, _ctrlDiscipline.text,
                DateTime(2024,7,1), DateTime(2024,12,31), _eventList),
          ),
        ],
      ),
    );
  }
}
