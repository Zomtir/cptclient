import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/fields/ConfirmationField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/pages/EventDetailOwnershipPage.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailRegularPage extends StatefulWidget {
  final UserSession session;
  final Event event;

  EventDetailRegularPage({
    super.key,
    required this.session,
    required this.event,
  });

  @override
  EventDetailRegularPageState createState() => EventDetailRegularPageState();
}

class EventDetailRegularPageState extends State<EventDetailRegularPage> {
  bool _bookmarked = false;
  bool _ownership = false;

  Confirmation _leaderRegistration = Confirmation.empty;
  Confirmation _participantRegistration = Confirmation.empty;
  bool _participantPresence = false;
  bool _leaderPresence = false;
  Confirmation _supporterRegistration = Confirmation.empty;
  bool _supporterPresence = false;

  EventDetailRegularPageState();

  @override
  void initState() {
    super.initState();
    _updateBookmark();
    _updateOwnership();
    _updateParticipantRegistration();
    _updateParticipantPresence();
    _updateLeaderRegistration();
    _updateLeaderPresence();
    _updateSupporterRegistration();
    _updateSupporterPresence();
  }

  Future<void> _handleSwitchOwner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailOwnershipPage(
          session: widget.session,
          eventID: widget.event.id,
        ),
      ),
    );
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

  void _handleBookmark(bool bookmark) async {
    await api_regular.event_bookmark_edit(widget.session, widget.event, bookmark);
    _updateBookmark();
  }

  Future<void> _updateBookmark() async {
    bool? bookmarked = await api_regular.event_bookmark_true(widget.session, widget.event);
    if (bookmarked == null) return;

    setState(() {
      _bookmarked = bookmarked;
    });
  }

  Future<void> _updateOwnership() async {
    bool? ownership = await api_regular.event_owner_true(widget.session, widget.event);
    if (ownership == null) return;

    setState(() => _ownership = ownership);
  }

  Future<void> _updateParticipantRegistration() async {
    Confirmation? registration = await api_regular.event_participant_registration_info(widget.session, widget.event);
    if (registration == null) return;

    setState(() => _participantRegistration = registration);
  }

  Future<void> _updateParticipantPresence() async {
    bool? presence = await api_regular.event_participant_presence_true(widget.session, widget.event);
    if (presence == null) return;

    setState(() => _participantPresence = presence);
  }

  Future<void> _updateLeaderRegistration() async {
    Confirmation? registration = await api_regular.event_leader_registration_info(widget.session, widget.event);
    if (registration == null) return;

    setState(() => _leaderRegistration = registration);
  }

  Future<void> _updateLeaderPresence() async {
    bool? presence = await api_regular.event_leader_presence_true(widget.session, widget.event);
    if (presence == null) return;

    setState(() => _leaderPresence = presence);
  }

  Future<void> _updateSupporterRegistration() async {
    Confirmation? registration = await api_regular.event_supporter_registration_info(widget.session, widget.event);
    if (registration == null) return;

    setState(() => _supporterRegistration = registration);
  }

  Future<void> _updateSupporterPresence() async {
    bool? presence = await api_regular.event_supporter_presence_true(widget.session, widget.event);
    if (presence == null) return;

    setState(() => _supporterPresence = presence);
  }

  void _handleParticipantRegistration(Confirmation? confirmation) async {
    await api_regular.event_participant_registration_edit(widget.session, widget.event, confirmation);
    _updateParticipantRegistration();
  }

  void _handleParticipantPresence(bool presence) async {
    if (presence) {
      await api_regular.event_participant_presence_add(widget.session, widget.event);
    } else {
      await api_regular.event_participant_presence_remove(widget.session, widget.event);
    }
    _updateParticipantPresence();
  }

  void _handleLeaderRegistration(Confirmation? confirmation) async {
    await api_regular.event_leader_registration_edit(widget.session, widget.event, confirmation);
    _updateLeaderRegistration();
  }

  void _handleLeaderPresence(bool presence) async {
    if (presence) {
      await api_regular.event_leader_presence_add(widget.session, widget.event);
    } else {
      await api_regular.event_leader_presence_remove(widget.session, widget.event);
    }
    _updateLeaderPresence();
  }

  void _handleSupporterRegistration(Confirmation? confirmation) async {
    await api_regular.event_supporter_registration_edit(widget.session, widget.event, confirmation);
    _updateSupporterRegistration();
  }

  void _handleSupporterPresence(bool presence) async {
    if (presence) {
      await api_regular.event_supporter_presence_add(widget.session, widget.event);
    } else {
      await api_regular.event_supporter_presence_remove(widget.session, widget.event);
    }
    _updateSupporterPresence();
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
          if (_ownership) AppButton(text: "Go to Owner Page", onPressed: _handleSwitchOwner),
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
            child: Text(widget.event.note!),
          ),
          Divider(),
          AppInfoRow(
            info: AppLocalizations.of(context)!.actionBookmark,
            child: IconButton(
              icon: _bookmarked ? Icon(Icons.star) : Icon(Icons.star_border),
              onPressed: () => _handleBookmark(!_bookmarked),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventOwner,
            child: _ownership ? Icon(Icons.castle) : Icon(Icons.castle_outlined),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventParticipant}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _participantRegistration,
              onChanged: _handleParticipantRegistration,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventParticipant}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _participantPresence ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleParticipantPresence(!_participantPresence),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventLeader}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _leaderRegistration,
              onChanged: _handleLeaderRegistration,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventLeader}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _leaderPresence ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleLeaderPresence(!_leaderPresence),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventSupporter}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _supporterRegistration,
              onChanged: _handleSupporterRegistration,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventSupporter}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _supporterPresence ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleSupporterPresence(!_supporterPresence),
            ),
          ),
        ],
      ),
    );
  }
}
