import 'package:cptclient/api/owner/event/imports.dart' as api_owner;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/MenuSection.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailOwnershipPage extends StatefulWidget {
  final UserSession session;
  final int eventID;
  
  EventDetailOwnershipPage({super.key, required this.session, required this.eventID});

  @override
  EventDetailOwnershipPageState createState() => EventDetailOwnershipPageState();
}

class EventDetailOwnershipPageState extends State<EventDetailOwnershipPage> {
  Event? event;

  EventDetailOwnershipPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    Event? event = await api_owner.event_info(widget.session, widget.eventID);

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
          onSubmit: api_owner.event_edit,
        ),
      ),
    );

    _update();
  }

  _handleDelete() async {
    if(!await api_owner.event_delete(widget.session, event!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleParticipantPresences() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantPresences,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_owner.event_participant_presence_pool(widget.session, event!),
          onCallSelected: () => api_owner.event_participant_presence_list(widget.session, event!),
          onCallAdd: (user) => api_owner.event_participant_presence_add(widget.session, event!, user),
          onCallRemove: (user) => api_owner.event_participant_presence_remove(widget.session, event!, user),
        ),
      ),
    );
  }

  Future<void> _handleLeaderPresences() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventLeaderPresences,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_owner.event_leader_presence_pool(widget.session, event!),
          onCallSelected: () => api_owner.event_leader_presence_list(widget.session, event!),
          onCallAdd: (user) => api_owner.event_leader_presence_add(widget.session, event!, user),
          onCallRemove: (user) => api_owner.event_leader_presence_remove(widget.session, event!, user),
        ),
      ),
    );
  }

  Future<void> _handleSupporterPresences() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventSupporterPresences,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_owner.event_supporter_presence_pool(widget.session, event!),
          onCallSelected: () => api_owner.event_supporter_presence_list(widget.session, event!),
          onCallAdd: (user) => api_owner.event_supporter_presence_add(widget.session, event!, user),
          onCallRemove: (user) => api_owner.event_supporter_presence_remove(widget.session, event!, user),
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
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_owner_list(widget.session, event!),
          onCallAdd: (user) => api_owner.event_owner_add(widget.session, event!, user),
          onCallRemove: (user) => api_owner.event_owner_remove(widget.session, event!, user),
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
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantPresences),
                onTap: _handleParticipantPresences,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantFilters),
                onTap: null,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantRegistrations),
                onTap: null,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderPresences),
                onTap: _handleLeaderPresences,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderFilters),
                onTap: null,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderRegistrations),
                onTap: null,
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterPresences),
                onTap: _handleSupporterPresences,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterFilters),
                onTap: null,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterRegistrations),
                onTap: null,
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
            ],
          ),
        ],
      ),
    );
  }

}
