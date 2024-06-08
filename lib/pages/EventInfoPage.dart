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

  bool _registeredParticipant = false;
  bool _actualParticipant = false;
  bool _registeredOwner = false;
  bool _actualOwner = false;

  EventInfoPageState();

  @override
  void initState() {
    super.initState();
    _updateBookmark();
    _updateParticipant();
    _updateOwner();
  }

  Future<void> _updateBookmark() async {
    bool? bookmarked = await api_regular.event_bookmark_true(widget.session, widget.event);
    if (bookmarked == null) return;

    setState(() {
      _bookmarked = bookmarked;
    });
  }

  Future<void> _updateParticipant() async {
    bool? actualParticipant = await api_regular.event_participant_true(widget.session, widget.event);
    if (actualParticipant == null) return;

    bool? registeredParticipant = await api_regular.event_participant_registration_true(widget.session, widget.event);
    if (registeredParticipant == null) return;

    setState(() {
      _actualParticipant = actualParticipant;
      _registeredParticipant = registeredParticipant;
    });
  }

  Future<void> _updateOwner() async {
    bool? actualOwner = await api_regular.event_owner_true(widget.session, widget.event);
    if (actualOwner == null) return;

    bool? registeredOwner = await api_regular.event_owner_registration_true(widget.session, widget.event);
    if (registeredOwner == null) return;

    setState(() {
      _actualOwner = actualOwner;
      _registeredOwner = registeredOwner;
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
    _updateBookmark();
  }
  
  void _handleParticipationRegistrationChange(bool registration) async {
    await api_regular.event_participant_registration_edit(widget.session, widget.event, registration);
    _updateParticipant();
  }

  void _handleOwnerRegistrationChange(bool registration) async {
    await api_regular.event_owner_registration_edit(widget.session, widget.event, registration);
    _updateOwner();
  }

  void _handleParticipationChange(bool participated) async {
    if (participated) {
      await api_regular.event_participant_add(widget.session, widget.event);
    } else {
      await api_regular.event_participant_remove(widget.session, widget.event);
    }
    _updateParticipant();
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
            info: AppLocalizations.of(context)!.eventKey,
            child: Text(widget.event.key),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventTitle,
            child: Text(widget.event.title),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventBegin,
            child: Text(widget.event.begin.fmtDate(context)),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventEnd,
            child: Text(widget.event.end.fmtDate(context)),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventLocation,
            child: Text(widget.event.location!.name),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventPublic,
            child: Checkbox(
              value: widget.event.public,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventScrutable,
            child: Checkbox(
              value: widget.event.scrutable,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventNote,
            child: Text(widget.event.note),
          ),
          Divider(),
          AppInfoRow(
            info: "Bookmark",
            child: IconButton(
              icon: _bookmarked ? Icon(Icons.star) : Icon(Icons.star_border),
              onPressed: () => _handleBookmarkChange(!_bookmarked),
            ),
          ),
          AppInfoRow(
            info: "Register as Participant",
            child: IconButton(
              icon: _registeredParticipant ? Icon(Icons.person_remove) : Icon(Icons.person_add_outlined),
              onPressed: () => _handleParticipationRegistrationChange(!_registeredParticipant),
            ),
          ),
          AppInfoRow(
            info: "Participation",
            child: IconButton(
              icon: _actualParticipant ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleParticipationChange(!_actualParticipant),
            ),
          ),
          AppInfoRow(
            info: "Register as Owner",
            child: IconButton(
              icon: _registeredOwner ? Icon(Icons.remove_moderator) : Icon(Icons.add_moderator_outlined),
              onPressed: () => _handleOwnerRegistrationChange(!_registeredOwner),
            ),
          ),
          AppInfoRow(
            info: "Ownership",
            child: IconButton(
              icon: _actualOwner ? Icon(Icons.house) : Icon(Icons.house_outlined),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
