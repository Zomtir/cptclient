import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
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

  Future<void> _handleSwitchAdmin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailManagementPage(
          session: widget.session,
          eventID: widget.event.id,
        ),
      ),
    );
  }

  // ignore: unused_element
  void _handleBookmarkAdd() async {
    //await api_regular.event_like_add(widget.session, widget.event);
  }

  // ignore: unused_element
  void _handleBookmarkRemove() async {
    //await api_regular.event_like_remove(widget.session, widget.event);
  }

  // ignore: unused_element
  void _handleRegistrationAdd() async {
    //await api_regular.event_participant_add(widget.session, widget.event);
  }

  // ignore: unused_element
  void _handleRegistrationRemove() async {
    //await api_regular.event_participant_remove(widget.session, widget.event);
  }

  // ignore: unused_element
  void _handleParticipationAdd() async {
    //await api_regular.event_participant_add(widget.session, widget.event);
  }

  // ignore: unused_element
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
          if (widget.session.right!.event.read) AppButton(text: "Go to Admin Page", onPressed: _handleSwitchAdmin),
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
            child: Text(widget.event.location!.name),
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
          AppInfoRow(
            info: Text("Bookmark"),
            child: Checkbox(
              value: false,
              onChanged: (bool? value) {  },
            ),
          ),
          AppInfoRow(
            info: Text("Register"),
            child: Checkbox(
              value: false,
              onChanged: (bool? value) {  },
            ),
          ),
          AppInfoRow(
            info: Text("Participate"),
            child: Checkbox(
              value: false,
              onChanged: (bool? value) {  },
            ),
          ),
          //Tooltip(message: "Bookmark", child: IconButton(icon: Icon(Icons.star), onPressed: _handleBookmarkAdd)),
          //Tooltip(message: "Register", child: IconButton(icon: Icon(Icons.group_add), onPressed: _handleRegistrationAdd)),
          //Tooltip(message: "Participate", child: IconButton(icon: Icon(Icons.chair_alt), onPressed: _handleParticipationAdd)),
        ],
      ),
    );
  }
}
