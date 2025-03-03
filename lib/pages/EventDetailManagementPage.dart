import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/api/anon/course.dart' as api_anon;
import 'package:cptclient/api/anon/organisation.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/FilterPage.dart';
import 'package:cptclient/material/pages/ListPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventCourseEditPage.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/pages/EventExportPage.dart';
import 'package:cptclient/pages/EventStatisticOrganisationPage.dart';
import 'package:cptclient/pages/EventStatisticPacklistPage.dart';
import 'package:flutter/material.dart';

class EventDetailManagementPage extends StatefulWidget {
  final UserSession session;
  final int eventID;

  EventDetailManagementPage({super.key, required this.session, required this.eventID});

  @override
  EventDetailManagementPageState createState() => EventDetailManagementPageState();
}

class EventDetailManagementPageState extends State<EventDetailManagementPage> {
  final TextEditingController _ctrlNote = TextEditingController();
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
      _ctrlNote.text = event.note ?? "";
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
          onPasswordChange: api_admin.event_password_edit,
        ),
      ),
    );

    _update();
  }

  _handleExport() async {
    Credential? credits = await api_admin.event_credential(widget.session, widget.eventID);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventExportPage(
          session: widget.session,
          event: event!,
          credits: credits!,
        ),
      ),
    );
  }

  _handleDelete() async {
    if (!await api_admin.event_delete(widget.session, event!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleNote() async {
    event!.note = _ctrlNote.text;
    await api_admin.event_edit(widget.session, event!);
    _update();
  }

  Future<void> _handleOwners() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwners,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_owner_list(widget.session, event!),
          onCallAdd: (user) => api_admin.event_owner_add(widget.session, event!, user),
          onCallRemove: (user) => api_admin.event_owner_remove(widget.session, event!, user),
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
          callInfo: () => api_admin.event_course_info(widget.session, event!),
          callEdit: (course) => api_admin.event_course_edit(widget.session, event!, course),
        ),
      ),
    );
  }

  Future<void> _handleAttendancePresences(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantPresences,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_admin.event_attendance_presence_pool(widget.session, event!, role),
          onCallSelected: () => api_admin.event_attendance_presence_list(widget.session, event!, role),
          onCallAdd: (user) => api_admin.event_attendance_presence_add(widget.session, event!, user, role),
          onCallRemove: (user) => api_admin.event_attendance_presence_remove(widget.session, event!, user, role),
        ),
      ),
    );
  }

  Future<void> _handleAttendanceFilters(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantFilters,
          tile: AppEventTile(event: event!),
          onCallAvailable: () => api_regular.user_list(widget.session),
          onCallSelected: () => api_admin.event_attendance_filter_list(widget.session, event!.id, role),
          onCallEdit: (user, access) =>
              api_admin.event_attendance_filter_edit(widget.session, event!.id, user.id, role, access),
          onCallRemove: (user) => api_admin.event_attendance_filter_remove(widget.session, event!.id, user.id, role),
        ),
      ),
    );
  }

  Future<void> _handleAttendanceRegistrations(String role) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: AppLocalizations.of(context)!.pageEventParticipantRegistrations,
          tile: AppEventTile(event: event!),
          onCallList: () => api_admin.event_attendance_registration_list(widget.session, event!, role),
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

  Future<void> _handleStatisticOrganisation() async {
    List<Organisation> organisations = await api_anon.organisation_list();
    Organisation? organisation = await showTilePicker(context: context, items: organisations);

    if (organisation == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventStatisticOrganisationPage(
          session: widget.session,
          event: event!,
          organisation: organisation,
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
                icon: const Icon(Icons.import_export),
                onPressed: _handleExport,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _handleDelete,
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
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantPresences),
                onTap: () => _handleAttendancePresences('PARTICIPANT'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantFilters),
                onTap: () => _handleAttendanceFilters('PARTICIPANT'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventParticipantRegistrations),
                onTap: () => _handleAttendanceRegistrations('PARTICIPANT'),
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderPresences),
                onTap: () => _handleAttendancePresences('LEADER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderFilters),
                onTap: () => _handleAttendanceFilters('LEADER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventLeaderRegistrations),
                onTap: () => _handleAttendanceRegistrations('LEADER'),
              ),
            ],
          ),
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterPresences),
                onTap: () => _handleAttendancePresences('SUPPORTER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterFilters),
                onTap: () => _handleAttendanceFilters('SUPPORTER'),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventSupporterRegistrations),
                onTap: () => _handleAttendanceRegistrations('SUPPORTER'),
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
          Divider(),
          MenuSection(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventStatisticPacklist),
                onTap: _handleStatisticPacklist,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.pageEventStatisticOrganisation),
                onTap: _handleStatisticOrganisation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
