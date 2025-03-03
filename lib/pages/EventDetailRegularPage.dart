import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/ConfirmationField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/EventDetailManagementPage.dart';
import 'package:cptclient/pages/EventDetailOwnershipPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:flutter/material.dart';

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

  final Map<String, Confirmation> _attendanceRegistration = {
    'PARTICIPANT': Confirmation.empty,
    'LEADER': Confirmation.empty,
    'SUPPORTER': Confirmation.empty,
  };

  final Map<String, bool> _attendancePresence = {
    'PARTICIPANT': false,
    'LEADER': false,
    'SUPPORTER': false,
  };

  EventDetailRegularPageState();

  @override
  void initState() {
    super.initState();
    _updateBookmark();
    _updateOwnership();
    _updateAttendanceRegistration('PARTICIPANT');
    _updateAttendancePresence('PARTICIPANT');
    _updateAttendanceRegistration('LEADER');
    _updateAttendancePresence('LEADER');
    _updateAttendanceRegistration('SUPPORTER');
    _updateAttendancePresence('SUPPORTER');
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

  Future<void> _updateAttendanceRegistration(String role) async {
    Confirmation? registration =
        await api_regular.event_attendance_registration_info(widget.session, widget.event, role);
    if (registration == null) return;

    setState(() => _attendanceRegistration[role] = registration);
  }

  Future<void> _updateAttendancePresence(String role) async {
    bool? presence = await api_regular.event_attendance_presence_true(widget.session, widget.event, role);
    if (presence == null) return;

    setState(() => _attendancePresence[role] = presence);
  }

  void _handleAttendanceRegistration(String role, Confirmation? confirmation) async {
    await api_regular.event_attendance_registration_edit(widget.session, widget.event, role, confirmation);
    _updateAttendanceRegistration(role);
  }

  void _handleAttendancePresence(String role, bool presence) async {
    if (presence) {
      await api_regular.event_attendance_presence_add(widget.session, widget.event, role);
    } else {
      await api_regular.event_attendance_presence_remove(widget.session, widget.event, role);
    }
    _updateAttendancePresence(role);
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
            info:
                "${AppLocalizations.of(context)!.eventParticipant}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _attendanceRegistration['PARTICIPANT']!,
              onChanged: (confirmation) => _handleAttendanceRegistration('PARTICIPANT', confirmation),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventParticipant}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _attendancePresence['PARTICIPANT']! ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleAttendancePresence('PARTICIPANT', !_attendancePresence['PARTICIPANT']!),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventLeader}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _attendanceRegistration['LEADER']!,
              onChanged: (confirmation) => _handleAttendanceRegistration('LEADER', confirmation),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventLeader}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _attendancePresence['LEADER']! ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleAttendancePresence('LEADER', !_attendancePresence['LEADER']!),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventSupporter}: ${AppLocalizations.of(context)!.eventRegistration}",
            child: ConfirmationField(
              confirmation: _attendanceRegistration['SUPPORTER']!,
              onChanged: (confirmation) => _handleAttendanceRegistration('SUPPORTER', confirmation),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.eventSupporter}: ${AppLocalizations.of(context)!.eventPresence}",
            child: IconButton(
              icon: _attendancePresence['SUPPORTER']! ? Icon(Icons.chair) : Icon(Icons.chair_outlined),
              onPressed: () => _handleAttendancePresence('SUPPORTER', !_attendancePresence['SUPPORTER']!),
            ),
          ),
        ],
      ),
    );
  }
}
