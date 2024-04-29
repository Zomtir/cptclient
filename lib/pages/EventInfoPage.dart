import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
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
  bool _bookmarked = false;

  //bool _registered = false;
  bool _participated = false;

  EventInfoPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    bool? bookmarked = await api_regular.event_bookmark_true(widget.session, widget.event);
    if (bookmarked == null) return;

    bool? participated = await api_regular.event_participant_true(widget.session, widget.event);
    if (participated == null) return;

    setState(() {
      _bookmarked = bookmarked;
      _participated = participated;
    });
  }

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

  void _handleBookmarkChange(bool bookmark) async {
    await api_regular.event_bookmark_edit(widget.session, widget.event, bookmark);
    _update();
  }

  // ignore: unused_element
  void _handleRegistrationChange(bool registration) async {
    //await api_regular.event_participant_add(widget.session, widget.event);
    //await api_regular.event_participant_remove(widget.session, widget.event);
  }

  void _handleParticipationChange(bool participated) async {
    if (participated) {
      await api_regular.event_participant_add(widget.session, widget.event);
    } else {
      await api_regular.event_participant_remove(widget.session, widget.event);
    }
    _update();
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
            child: IconButton(
              icon: _bookmarked ? Icon(Icons.star) : Icon(Icons.star_border),
              onPressed: () => _handleBookmarkChange(!_bookmarked),
            ),
          ),
          /*AppInfoRow(
            info: Text("Registered"),
            child: IconButton(
              icon: _registered ? Icon(Icons.person_remove) : Icon(Icons.person_add_outlined),
              onPressed: () => _handleBookmarkChange(!_bookmarked),
            ),
          ),*/
          AppInfoRow(
            info: Text("Participation"),
            child: IconButton(
              icon: _participated ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleParticipationChange(!_participated),
            ),
          ),
        ],
      ),
    );
  }
}
