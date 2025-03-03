import 'package:cptclient/api/service/event.dart' as api_service;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:flutter/material.dart';

class EnrollPage extends StatefulWidget {
  final EventSession session;

  EnrollPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EnrollPageState();
}

class EnrollPageState extends State<EnrollPage> {
  final TextEditingController _ctrlNote = TextEditingController();
  Event? _event;

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    if (widget.session.token.isEmpty) navi.logoutEvent(context);
    _update();
  }

  void _update() async {
    Event? event = await api_service.event_info(widget.session);
    if (event == null) return;

    setState(() {
      _event = event;
      _ctrlNote.text = event.note!;
    });
  }

  Future<void> _handleAttendance(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantPresences,
          tile: AppEventTile(event: _event!),
          onCallAvailable: () => api_service.event_attendance_presence_pool(widget.session, role),
          onCallSelected: () => api_service.event_attendance_presence_list(widget.session, role),
          onCallAdd: (user) => api_service.event_attendance_presence_add(widget.session, user, role),
          onCallRemove: (user) => api_service.event_attendance_presence_remove(widget.session, user, role),
        ),
      ),
    );
  }

  Future<void> _handleNote() async {
    await api_service.event_note_edit(widget.session, _ctrlNote.text);
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventDetails),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logoutEvent(context),
          )
        ],
      ),
      body: AppBody(
        children: [
          AppEventTile(event: _event!),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantPresences),
                onTap: () => _handleAttendance('PARTICIPANT'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderPresences),
                onTap: () => _handleAttendance('LEADER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterPresences),
                onTap: () => _handleAttendance('SUPPORTER'),
              ),
            ],
          ),
          ListTile(
            title: TextField(
              minLines: 3,
              maxLines: 10,
              controller: _ctrlNote,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.eventNote,
                suffixIcon: IconButton(
                  onPressed: _handleNote,
                  icon: Icon(Icons.save),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
