import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/MenuSection.dart';
import 'package:cptclient/material/pages/ListPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/pages/EventStatisticDivisionPage.dart';
import 'package:cptclient/pages/EventStatisticPacklistPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailManagementPage extends StatefulWidget {
  final UserSession session;
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
          title: AppLocalizations.of(context)!.pageEventParticipants,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_admin.event_participant_pool(widget.session, event!),
          onCallSelected: () => api_admin.event_participant_list(widget.session, event!),
          onCallAdd: (user) => api_admin.event_participant_add(widget.session, event!, user),
          onCallRemove: (user) => api_admin.event_participant_remove(widget.session, event!, user),
        ),
      ),
    );
  }

  Future<void> _handleParticipantRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: () => api_admin.event_participant_registration_list(widget.session, event!),
        ),
      ),
    );
  }

  Future<void> _handleParticipantInvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantInvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_participant_invite_list(widget.session, event!.id),
          onCallAdd: (user) => api_admin.event_participant_invite_add(widget.session, event!.id, user.id),
          onCallRemove: (user) => api_admin.event_participant_invite_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleParticipantUninvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantUninvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_participant_uninvite_list(widget.session, event!.id),
          onCallAdd: (user) => api_admin.event_participant_uninvite_add(widget.session, event!.id, user.id),
          onCallRemove: (user) => api_admin.event_participant_uninvite_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleOwners() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwners,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_admin.event_owner_pool(widget.session, event!),
          onCallSelected: () => api_admin.event_owner_list(widget.session, event!),
          onCallAdd: (user) => api_admin.event_owner_add(widget.session, event!, user),
          onCallRemove: (user) => api_admin.event_owner_remove(widget.session, event!, user),
        ),
      ),
    );
  }

  Future<void> _handleOwnerRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwnerRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: () => api_admin.event_owner_registration_list(widget.session, event!),
        ),
      ),
    );
  }

  Future<void> _handleOwnerInvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwnerInvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_owner_invite_list(widget.session, event!.id),
          onCallAdd: (user) => api_admin.event_owner_invite_add(widget.session, event!.id, user.id),
          onCallRemove: (user) => api_admin.event_owner_invite_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleOwnerUninvites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwnerUninvites,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_owner_uninvite_list(widget.session, event!.id),
          onCallAdd: (user) => api_admin.event_owner_uninvite_add(widget.session, event!.id, user.id),
          onCallRemove: (user) => api_admin.event_owner_uninvite_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleStatisticPacklist() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventStatisticPacklistPage(session: widget.session, event: event!),
      ),
    );
  }

  Future<void> _handleStatisticDivision() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventStatisticDivisionPage(session: widget.session, event: event!),
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
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipants),
                onTap: _handleParticipants,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantInvites),
                onTap: _handleParticipantInvites,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantUninvites),
                onTap: _handleParticipantUninvites,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantRegistrations),
                onTap: _handleParticipantRegistrations,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventOwners),
                onTap: _handleOwners,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventOwnerInvites),
                onTap: _handleOwnerInvites,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventOwnerUninvites),
                onTap: _handleOwnerUninvites,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventOwnerRegistrations),
                onTap: _handleOwnerRegistrations,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventStatisticPacklist),
                onTap: _handleStatisticPacklist,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventStatisticDivision),
                onTap: _handleStatisticDivision,
              ),
            ],
          ),
        ],
      ),
    );
  }

}
