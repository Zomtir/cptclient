import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventInfoPage extends StatefulWidget {
  final Session session;
  final Event event;

  EventInfoPage({
    super.key,
    required this.session,
    required this.event,
  });

  @override
  EventInfoPageState createState() => EventInfoPageState();
}

class EventInfoPageState extends State<EventInfoPage> {

  EventInfoPageState();

  void _handleLikeAdd() async {
    //await api_regular.event_like_add(widget.session, widget.event);
  }

  void _handleLikeRemove() async {
    //await api_regular.event_like_remove(widget.session, widget.event);
  }

  void _handleParticipationAdd() async {
    //await api_regular.event_participant_add(widget.session, widget.event);
  }

  void _handleParticipationRemove() async {
    //await api_regular.event_participant_remove(widget.session, widget.event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventInfo),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventKey),
            child: Text(widget.event.key),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventTitle),
            child: Text(widget.event.title),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventBegin),
            child: Text(widget.event.begin.fmtDate(context)),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventEnd),
            child: Text(widget.event.end.fmtDate(context)),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventLocation),
            child: Text(widget.event.location!.title),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventPublic),
            child: Checkbox(
              value: widget.event.public,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventScrutable),
            child: Checkbox(
              value: widget.event.scrutable,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.eventNote),
            child: Text(widget.event.note),
          ),
          Divider(),
          IconButton(icon: Icon(Icons.star), onPressed: _handleLikeAdd),
          IconButton(icon: Icon(Icons.group_add), onPressed: _handleParticipationAdd),
        ],
      ),
    );
  }
}
