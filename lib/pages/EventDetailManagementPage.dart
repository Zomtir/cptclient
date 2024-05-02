import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/ListPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailManagementPage extends StatefulWidget {
  final Session session;
  final int eventID;
  
  EventDetailManagementPage({super.key, required this.session, required this.eventID});

  @override
  EventDetailManagementPageState createState() => EventDetailManagementPageState();
}

class EventDetailManagementPageState extends State<EventDetailManagementPage> {
  Event? event;

  EventDetailManagementPageState();

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

  Future<void> _handleParticipantRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipantRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: (session) => api_admin.event_participant_registration_list(session, event!),
        ),
      ),
    );
  }

  Future<void> _handleParticipantInvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipantInvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_admin.event_participant_invite_list(session, event!.id),
          onCallAdd: (session, user) => api_admin.event_participant_invite_add(session, event!.id, user.id),
          onCallRemove: (session, user) => api_admin.event_participant_invite_remove(session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleParticipantUninvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipantUninvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_admin.event_participant_uninvite_list(session, event!.id),
          onCallAdd: (session, user) => api_admin.event_participant_uninvite_add(session, event!.id, user.id),
          onCallRemove: (session, user) => api_admin.event_participant_uninvite_remove(session, event!.id, user.id),
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

  Future<void> _handleOwnerRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventOwnerRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: (session) => api_admin.event_owner_registration_list(session, event!),
        ),
      ),
    );
  }

  Future<void> _handleOwnerInvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventOwnerInvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_admin.event_owner_invite_list(session, event!.id),
          onCallAdd: (session, user) => api_admin.event_owner_invite_add(session, event!.id, user.id),
          onCallRemove: (session, user) => api_admin.event_owner_invite_remove(session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleOwnerUninvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventOwnerUninvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_admin.event_owner_uninvite_list(session, event!.id),
          onCallAdd: (session, user) => api_admin.event_owner_uninvite_add(session, event!.id, user.id),
          onCallRemove: (session, user) => api_admin.event_owner_uninvite_remove(session, event!.id, user.id),
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
            text: AppLocalizations.of(context)!.pageEventParticipantRegistrations,
            onPressed: _handleParticipantRegistrations,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventParticipantInvites,
            onPressed: _handleParticipantInvites,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventParticipantUninvites,
            onPressed: _handleParticipantUninvites,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwners,
            onPressed: _handleOwners,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwnerRegistrations,
            onPressed: _handleOwnerRegistrations,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwnerInvites,
            onPressed: _handleOwnerInvites,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageEventOwnerUninvites,
            onPressed: _handleOwnerUninvites,
          ),
        ],
      ),
    );
  }

}
