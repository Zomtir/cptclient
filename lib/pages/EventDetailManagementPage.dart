import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassDetailManagementPage extends StatefulWidget {
  final Session session;
  final int eventID;
  
  ClassDetailManagementPage({super.key, required this.session, required this.eventID});

  @override
  ClassDetailManagementPageState createState() => ClassDetailManagementPageState();
}

class ClassDetailManagementPageState extends State<ClassDetailManagementPage> {
  Event? event;

  ClassDetailManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    Event? event = await api_admin.event_info(widget.session, widget.eventID);

    if (event == null) return;

    setState(() {
      this.event = event;
    });
  }

  _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          event: event!,
          isDraft: false,
          onSubmit: api_admin.event_edit,
        ),
      ),
    );

    _update();
  }

  _handleDelete() async {
    if(!await api_admin.event_delete(widget.session, event!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipants,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_admin.event_participant_pool(session, event!),
          onCallSelected: (session) => api_admin.event_participant_list(session, event!),
          onCallAdd: (session, user) => api_admin.event_participant_add(session, event!, user),
          onCallRemove: (session, user) => api_admin.event_participant_remove(session, event!, user),
        ),
      ),
    );
  }

  Future<void> _handleOwners() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventOwners,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_admin.event_owner_pool(session, event!),
          onCallSelected: (session) => api_admin.event_owner_list(session, event!),
          onCallAdd: (session, user) => api_admin.event_owner_add(session, event!, user),
          onCallRemove: (session, user) => api_admin.event_owner_remove(session, event!, user),
        ),
      ),
    );
  }

  @override
  Widget build (BuildContext context) {
    if (event == null) {
      return Icon(Icons.downloading);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventDetails),
      ),
      body: AppBody(
        children: [
          AppEventTile(
            event: event!,
            trailing: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _handleEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _handleDelete,
              ),
            ],
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventParticipants,
            onPressed: _handleParticipants,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwners,
            onPressed: _handleOwners,
          ),
        ],
      ),
    );
  }

}
