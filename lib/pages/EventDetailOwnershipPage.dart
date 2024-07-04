import 'package:cptclient/api/owner/event/imports.dart' as api_owner;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/FilterPage.dart';
import 'package:cptclient/material/pages/ListPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventCourseEditPage.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_course_anon.dart' as api_anon;
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
    if (!await api_owner.event_delete(widget.session, event!)) return;

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

  Future<void> _handleParticipantFilters() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantFilters,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_participant_filter_list(widget.session, event!.id),
          onCallEdit: (user, access) => api_owner.event_participant_filter_edit(widget.session, event!.id, user.id, access),
          onCallRemove: (user) => api_owner.event_participant_filter_remove(widget.session, event!.id, user.id),
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
          onCallList: () => api_owner.event_participant_registration_list(widget.session, event!),
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

  Future<void> _handleLeaderFilters() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<User>(
          title: AppLocalizations.of(context)!.pageEventLeaderFilters,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_leader_filter_list(widget.session, event!.id),
          onCallEdit: (user, access) => api_owner.event_leader_filter_edit(widget.session, event!.id, user.id, access),
          onCallRemove: (user) => api_owner.event_leader_filter_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleLeaderRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: AppLocalizations.of(context)!.pageEventLeaderRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: () => api_owner.event_leader_registration_list(widget.session, event!),
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

  Future<void> _handleSupporterFilters() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<User>(
          title: AppLocalizations.of(context)!.pageEventSupporterFilters,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_owner.event_supporter_filter_list(widget.session, event!.id),
          onCallEdit: (user, access) => api_owner.event_supporter_filter_edit(widget.session, event!.id, user.id, access),
          onCallRemove: (user) => api_owner.event_supporter_filter_remove(widget.session, event!.id, user.id),
        ),
      ),
    );
  }

  Future<void> _handleSupporterRegistrations() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: AppLocalizations.of(context)!.pageEventSupporterRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: () => api_owner.event_supporter_registration_list(widget.session, event!),
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

  Future<void> _handleCourse() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCourseEditPage(
          session: widget.session,
          event: event!,
          callList: () => api_anon.course_list(),
          callInfo: () => api_owner.event_course_info(widget.session, event!),
          callEdit: (course) => api_owner.event_course_edit(widget.session, event!, course),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: _handleParticipantFilters,
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
                title: Text(AppLocalizations.of(context)!.pageEventLeaderPresences),
                onTap: _handleLeaderPresences,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderFilters),
                onTap: _handleLeaderFilters,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderRegistrations),
                onTap: _handleLeaderRegistrations,
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
                onTap: _handleSupporterFilters,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterRegistrations),
                onTap: _handleSupporterRegistrations,
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
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventCourse),
                onTap: _handleCourse,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
