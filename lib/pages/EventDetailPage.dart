import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/api/admin/event/imports.dart' as api_admin;
import 'package:cptclient/api/anon/course.dart' as api_anon;
import 'package:cptclient/api/anon/location.dart' as api_anon;
import 'package:cptclient/api/anon/organisation.dart' as api_anon;
import 'package:cptclient/api/moderator/event/imports.dart' as api_mod;
import 'package:cptclient/api/owner/event/imports.dart' as api_owner;
import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/confirmation.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/organisation.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/json/valence.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/ChoiceDisplay.dart';
import 'package:cptclient/material/dialogs/ChoiceEdit.dart';
import 'package:cptclient/material/dialogs/DatePicker.dart';
import 'package:cptclient/material/dialogs/MultiChoiceEdit.dart';
import 'package:cptclient/material/dialogs/TextEdit.dart';
import 'package:cptclient/material/dialogs/TilePicker.dart';
import 'package:cptclient/material/dialogs/TimePicker.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/material/layouts/MenuSection.dart';
import 'package:cptclient/material/pages/FilterPage.dart';
import 'package:cptclient/material/pages/ListPage.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/material/widgets/SectionToggle.dart';
import 'package:cptclient/pages/EventExportPage.dart';
import 'package:cptclient/pages/EventStatisticOrganisationPage.dart';
import 'package:cptclient/pages/EventStatisticPacklistPage.dart';
import 'package:cptclient/utils/clipboard.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final UserSession session;
  final int eventID;

  EventDetailPage({
    super.key,
    required this.session,
    required this.eventID,
  });

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  Event? _event;
  bool _adminship_read = false;
  bool _adminship_write = false;
  bool _ownership = false;
  bool _moderatorship = false;
  bool _bookmarked = false;
  Credential? _credential;
  bool _credentialCleartext = false;

  final Map<String, Confirmation?> _attendanceRegistration = {
    'PARTICIPANT': null,
    'LEADER': null,
    'SUPPORTER': null,
  };

  final Map<String, Valence?> _attendancePresence = {
    'PARTICIPANT': Valence.no,
    'LEADER': Valence.no,
    'SUPPORTER': Valence.no,
  };

  EventDetailPageState();

  @override
  void initState() {
    super.initState();

    _adminship_read = widget.session.right!.event.read;
    _adminship_write = widget.session.right!.event.write;

    _updateOwnership();
    _updateModeratorship();

    _updateEvent();
    _updateCredential();
    _updateBookmark();

    _updateAttendanceRegistration('PARTICIPANT');
    _updateAttendancePresence('PARTICIPANT');
    _updateAttendanceRegistration('LEADER');
    _updateAttendancePresence('LEADER');
    _updateAttendanceRegistration('SUPPORTER');
    _updateAttendancePresence('SUPPORTER');
  }

  Future<void> _updateOwnership() async {
    Result<bool>? result = await api_regular.event_owner_true(widget.session, widget.eventID);
    if (result is! Success) return;
    setState(() => _ownership = result.unwrap());
  }

  Future<void> _updateModeratorship() async {
    Result<bool>? result = await api_regular.event_moderator_true(widget.session, widget.eventID);
    if (result is! Success) return;
    setState(() => _moderatorship = result.unwrap());
  }

  Future<void> _updateEvent() async {
    Result<Event>? result;
    if (_adminship_read) {
      result = await api_admin.event_info(widget.session, widget.eventID);
    } else if (_ownership) {
      result = await api_owner.event_info(widget.session, widget.eventID);
    } else if (_moderatorship) {
      result = await api_mod.event_info(widget.session, widget.eventID);
    }

    if (result is! Success) return;
    setState(() => _event = result!.unwrap());
  }

  Future<void> _updateCredential() async {
    Credential? credential = await api_admin.event_credential(widget.session, widget.eventID);
    setState(() => _credential = credential);
  }

  Future<void> _handleExport() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventExportPage(
          session: widget.session,
          event: _event!,
          credits: _credential!,
        ),
      ),
    );
  }

  void _handleBookmark(bool bookmark) async {
    await api_regular.event_bookmark_edit(widget.session, _event!, bookmark);
    _updateBookmark();
  }

  Future<void> _handleDelete() async {
    Result<()>? result;
    if (_adminship_read) {
      result = await api_admin.event_delete(widget.session, _event!);
    } else if (_ownership) {
      result = await api_owner.event_delete(widget.session, _event!);
    } else if (_moderatorship) {
      result = await api_mod.event_delete(widget.session, _event!);
    }

    if (result is! Success) return;
    Navigator.pop(context);
  }

  void _handleEvent() async {
    Result<()>? result;
    if (_adminship_write) {
      result = await api_admin.event_edit(widget.session, _event!);
    } else if (_ownership) {
      result = await api_owner.event_edit(widget.session, _event!);
    } else if (_moderatorship) {
      result = await api_mod.event_edit(widget.session, _event!);
    }

    if (result is! Success) return;
    _updateEvent();
  }

  Future<void> _handleOwners() async {
    callAvailable() => api_regular.user_list(widget.session);
    Future<List<User>> Function()? callSelected;
    Future<bool> Function(User)? callAdd;
    Future<bool> Function(User)? callRemove;

    if (_adminship_read) {
      callSelected = () => api_admin.event_owner_list(widget.session, _event!);
    } else if (_ownership) {
      callSelected = () => api_owner.event_owner_list(widget.session, _event!);
    } else if (_moderatorship) {
      callSelected = () => api_mod.event_owner_list(widget.session, _event!);
    }

    if (_adminship_write) {
      callAdd = (user) => api_admin.event_owner_add(widget.session, _event!, user);
      callRemove = (user) => api_admin.event_owner_remove(widget.session, _event!, user);
    } else if (_ownership) {
      callAdd = (user) => api_owner.event_owner_add(widget.session, _event!, user);
      callRemove = (user) => api_owner.event_owner_remove(widget.session, _event!, user);
    } else if (_moderatorship) {
      callAdd = (user) => api_mod.event_owner_add(widget.session, _event!, user);
      callRemove = (user) => api_mod.event_owner_remove(widget.session, _event!, user);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: AppLocalizations.of(context)!.pageEventOwners,
          tile: AppEventTile(event: _event!),
          onCallAvailable: callAvailable,
          onCallSelected: callSelected!,
          onCallAdd: callAdd!,
          onCallRemove: callRemove!,
        ),
      ),
    );

    _updateOwnership();
  }

  Future<void> _handleOwnerSelf(bool makeOwner) async {
    if (_adminship_write) {
      makeOwner
          ? api_admin.event_owner_add(widget.session, _event!, widget.session.user!)
          : api_admin.event_owner_remove(widget.session, _event!, widget.session.user!);
    } else if (_ownership) {
      makeOwner
          ? api_owner.event_owner_add(widget.session, _event!, widget.session.user!)
          : api_owner.event_owner_remove(widget.session, _event!, widget.session.user!);
    } else if (_moderatorship) {
      makeOwner
          ? api_mod.event_owner_add(widget.session, _event!, widget.session.user!)
          : api_mod.event_owner_remove(widget.session, _event!, widget.session.user!);
    }

    _updateOwnership();
  }

  Future<void> _handleCourse() async {
    late final Result<List<Course>> resultItems;
    if (_adminship_read) {
      resultItems = await api_admin.course_list(widget.session, active: true);
    } else if (_ownership) {
      resultItems = await api_anon.course_list();
    } else if (_moderatorship) {
      resultItems = await api_anon.course_list();
    }
    if (resultItems is! Success) return;

    late final Result<Course?> resultValue;
    if (_adminship_read) {
      resultValue = await api_admin.event_course_info(widget.session, _event!);
    } else if (_ownership) {
      resultValue = await api_owner.event_course_info(widget.session, _event!);
    } else if (_moderatorship) {
      resultValue = await api_mod.event_course_info(widget.session, _event!);
    }
    if (resultValue is! Success) return;

    callEdit(Course? course) => api_owner.event_course_edit(widget.session, _event!, course);

    useAppDialog<Course?>(
      context: context,
      widget: MultiChoiceEdit<Course>(
        items: resultItems.unwrap(),
        value: resultValue.unwrap(),
        builder: (course) => course.buildTile(context),
        nullable: true,
      ),
      onChanged: callEdit,
    );
  }

  Future<void> _handleAttendancePresences(String role, heading) async {
    Future<List<User>> Function()? callAvailable;
    Future<List<User>> Function()? callSelected;
    Future<bool> Function(User)? callAdd;
    Future<bool> Function(User)? callRemove;

    if (_adminship_read) {
      callAvailable = () => api_admin.event_attendance_presence_pool(widget.session, _event!, role);
      callSelected = () => api_admin.event_attendance_presence_list(widget.session, _event!, role);
    } else if (_ownership) {
      callAvailable = () => api_owner.event_attendance_presence_pool(widget.session, _event!, role);
      callSelected = () => api_owner.event_attendance_presence_list(widget.session, _event!, role);
    } else if (_moderatorship) {
      callAvailable = () => api_mod.event_attendance_presence_pool(widget.session, _event!, role);
      callSelected = () => api_mod.event_attendance_presence_list(widget.session, _event!, role);
    }

    if (_adminship_write) {
      callAdd = (user) => api_admin.event_attendance_presence_add(widget.session, _event!, user, role);
      callRemove = (user) => api_admin.event_attendance_presence_remove(widget.session, _event!, user, role);
    } else if (_ownership) {
      callAdd = (user) => api_owner.event_attendance_presence_add(widget.session, _event!, user, role);
      callRemove = (user) => api_owner.event_attendance_presence_remove(widget.session, _event!, user, role);
    } else if (_moderatorship) {
      callAdd = (user) => api_mod.event_attendance_presence_add(widget.session, _event!, user, role);
      callRemove = (user) => api_mod.event_attendance_presence_remove(widget.session, _event!, user, role);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          title: "$heading ${AppLocalizations.of(context)!.pageEventAttendancePresences}",
          tile: AppEventTile(event: _event!),
          onCallAvailable: callAvailable!,
          onCallSelected: callSelected!,
          onCallAdd: callAdd!,
          onCallRemove: callRemove!,
        ),
      ),
    );
  }

  Future<void> _handleAttendanceFilters(String role, String heading) async {
    Future<List<User>> Function()? callAvailable;
    Future<List<(User, bool)>> Function()? callSelected;
    Future<bool> Function(User, bool)? callEdit;
    Future<bool> Function(User)? callRemove;

    if (_adminship_read) {
      callAvailable = () => api_regular.user_list(widget.session);
      callSelected = () => api_admin.event_attendance_filter_list(widget.session, _event!.id, role);
    } else if (_ownership) {
      callAvailable = () => api_regular.user_list(widget.session);
      callSelected = () => api_owner.event_attendance_filter_list(widget.session, _event!.id, role);
    } else if (_moderatorship) {
      callAvailable = () => api_regular.user_list(widget.session);
      callSelected = () => api_mod.event_attendance_filter_list(widget.session, _event!.id, role);
    }

    if (_adminship_write) {
      callEdit =
          (user, access) => api_admin.event_attendance_filter_edit(widget.session, _event!.id, user.id, role, access);
      callRemove = (user) => api_admin.event_attendance_filter_remove(widget.session, _event!.id, user.id, role);
    } else if (_ownership) {
      callEdit =
          (user, access) => api_owner.event_attendance_filter_edit(widget.session, _event!.id, user.id, role, access);
      callRemove = (user) => api_owner.event_attendance_filter_remove(widget.session, _event!.id, user.id, role);
    } else if (_moderatorship) {
      callEdit =
          (user, access) => api_mod.event_attendance_filter_edit(widget.session, _event!.id, user.id, role, access);
      callRemove = (user) => api_mod.event_attendance_filter_remove(widget.session, _event!.id, user.id, role);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage<User>(
          title: "$heading ${AppLocalizations.of(context)!.pageEventAttendanceFilters}",
          tile: AppEventTile(event: _event!),
          onCallAvailable: callAvailable!,
          onCallSelected: callSelected!,
          onCallEdit: callEdit!,
          onCallRemove: callRemove!,
        ),
      ),
    );
  }

  Future<void> _handleAttendanceRegistrations(String role, String heading) async {
    Future<List<User>> Function()? callList;

    if (_adminship_read) {
      callList = () => api_admin.event_attendance_registration_list(widget.session, _event!, role);
    } else if (_ownership) {
      callList = () => api_owner.event_attendance_registration_list(widget.session, _event!, role);
    } else if (_moderatorship) {
      callList = () => api_mod.event_attendance_registration_list(widget.session, _event!, role);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage<User>(
          title: "$heading ${AppLocalizations.of(context)!.pageEventAttendanceRegistrations}",
          tile: AppEventTile(event: _event!),
          onCallList: callList!,
        ),
      ),
    );
  }

  Future<void> _handleStatisticPacklist() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventStatisticPacklistPage(session: widget.session, event: _event!),
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
          event: _event!,
          organisation: organisation,
        ),
      ),
    );
  }

  Future<void> _updateBookmark() async {
    bool? bookmarked = await api_regular.event_bookmark_true(widget.session, widget.eventID);
    if (bookmarked == null) return;

    setState(() {
      _bookmarked = bookmarked;
    });
  }

  Future<void> _updateAttendanceRegistration(String role) async {
    Confirmation? registration =
        await api_regular.event_attendance_registration_info(widget.session, widget.eventID, role);
    if (registration == null) return;

    setState(() => _attendanceRegistration[role] = registration);
  }

  Future<void> _updateAttendancePresence(String role) async {
    Valence? presence =
        Valence.fromBool(await api_regular.event_attendance_presence_true(widget.session, widget.eventID, role));
    if (presence == null) return;

    setState(() => _attendancePresence[role] = presence);
  }

  void _handleAttendanceRegistration(String role, Confirmation? confirmation) async {
    await api_regular.event_attendance_registration_edit(widget.session, widget.eventID, role, confirmation);
    _updateAttendanceRegistration(role);
  }

  void _handleAttendancePresence(String role, Valence presence) async {
    if (presence == Valence.yes) {
      await api_regular.event_attendance_presence_add(widget.session, _event!, role);
    } else {
      await api_regular.event_attendance_presence_remove(widget.session, _event!, role);
    }
    _updateAttendancePresence(role);
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return Icon(Icons.downloading);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventInfo),
        actions: [
          if (_credential != null)
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: _handleExport,
            ),
          IconButton(
            icon: _bookmarked ? Icon(Icons.star) : Icon(Icons.star_border),
            onPressed: () => _handleBookmark(!_bookmarked),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventTitle,
            child: ListTile(
              title: Text(_event!.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => clipText(_event!.title),
                    icon: Icon(Icons.copy),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String>(
                      context: context,
                      widget: TextEdit(
                        text: _event!.title,
                        minLength: 6,
                        maxLength: 100,
                        nullable: false,
                      ),
                      onChanged: (String t) {
                        setState(() => _event!.title = t);
                        _handleEvent();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventNote,
            child: ListTile(
              title: Text(_event!.note ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => clipText(_event!.note ?? ''),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<String?>(
                        context: context,
                        widget: TextEdit(
                          text: _event!.note ?? '',
                          minLength: 1,
                          maxLength: 500,
                          nullable: true,
                          maxLines: 20,
                        ),
                        onChanged: (note) {
                          setState(() => _event!.note = note == null ? null : (note.isEmpty ? null : note));
                          _handleEvent();
                        }),
                  ),
                ],
              ),
            ),
          ),
          SectionToggle(
            title: AppLocalizations.of(context)!.labelMoreDetails,
            children: [
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventKey,
                child: ListTile(
                  title: Text(_event!.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => clipText(_event!.key),
                        icon: Icon(Icons.copy),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => useAppDialog<String>(
                          context: context,
                          widget: TextEdit(
                            text: _event!.key,
                            minLength: 1,
                            maxLength: 12,
                            nullable: false,
                          ),
                          onChanged: (String key) {
                            setState(() => _event!.key = key);
                            _handleEvent();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_credential != null)
                AppInfoRow(
                  info: AppLocalizations.of(context)!.eventPassword,
                  child: ListTile(
                    title:
                        _credentialCleartext ? Text(_credential!.password!) : Text('•' * _credential!.password!.length),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_credentialCleartext ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                          onPressed: () => setState(() => _credentialCleartext = !_credentialCleartext),
                        ),
                        IconButton(
                          onPressed: () => clipText(_credential!.password!),
                          icon: Icon(Icons.copy),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => useAppDialog<String>(
                            context: context,
                            widget: TextEdit(
                              text: _credential!.password!,
                              minLength: 5,
                              maxLength: 20,
                              nullable: false,
                            ),
                            onChanged: (String pw) async {
                              api_admin.event_password_edit(widget.session, _event!, pw);
                              _updateCredential();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventBegin,
                child: ListTile(
                  title: Text(_event!.begin.fmtDateTime(context)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => clipText(formatIsoDateTime(_event!.begin) ?? ''),
                        icon: Icon(Icons.copy),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => useAppDialog<DateTime>(
                          context: context,
                          widget: DatePicker(initialDate: _event!.begin, nullable: false),
                          onChanged: (DateTime dt) {
                            setState(() => _event!.begin = dt);
                            _handleEvent();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.watch_later_outlined),
                        onPressed: () => useAppDialog<TimeOfDay>(
                          context: context,
                          widget: TimePicker(initialTime: TimeOfDay.fromDateTime(_event!.begin), nullable: false),
                          onChanged: (TimeOfDay tod) {
                            setState(() => _event!.begin = _event!.begin.withTime(tod));
                            _handleEvent();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventEnd,
                child: ListTile(
                  title: Text(_event!.end.fmtDateTime(context)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => clipText(formatIsoDateTime(_event!.end) ?? ''),
                        icon: Icon(Icons.copy),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => useAppDialog<DateTime>(
                          context: context,
                          widget: DatePicker(initialDate: _event!.end, nullable: false),
                          onChanged: (DateTime dt) {
                            setState(() => _event!.end = dt);
                            _handleEvent();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.watch_later_outlined),
                        onPressed: () => useAppDialog<TimeOfDay>(
                          context: context,
                          widget: TimePicker(initialTime: TimeOfDay.fromDateTime(_event!.end), nullable: false),
                          onChanged: (TimeOfDay tod) {
                            setState(() => _event!.end = _event!.end.withTime(tod));
                            _handleEvent();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventLocation,
                child: ListTile(
                  title: Text(_event!.location!.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => clipText(_event!.location!.name),
                        icon: Icon(Icons.copy),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          var items = await api_anon.location_list();
                          useAppDialog<Location?>(
                            context: context,
                            widget: MultiChoiceEdit<Location>(
                              items: items,
                              value: _event!.location!,
                              builder: (event) => event.buildTile(context),
                              nullable: false,
                            ),
                            onChanged: (Location? location) {
                              setState(() => _event!.location = location);
                              _handleEvent();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventPublic,
                child: ChoiceDisplay(
                  value: Valence.fromBool(_event!.public),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Valence>(
                      context: context,
                      widget: ChoiceEdit(value: Valence.fromBool(_event!.public)),
                      onChanged: (Valence v) {
                        setState(() => _event!.public = v.toBool());
                        _handleEvent();
                      },
                    ),
                  ),
                ),
              ),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventScrutable,
                child: ChoiceDisplay(
                  value: Valence.fromBool(_event!.scrutable),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Valence>(
                      context: context,
                      widget: ChoiceEdit(value: Valence.fromBool(_event!.scrutable)),
                      onChanged: (Valence v) {
                        setState(() => _event!.scrutable = v.toBool());
                        _handleEvent();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          SectionToggle(
            hidden: false,
            title: AppLocalizations.of(context)!.labelGeneralAttendence,
            children: [
              buildCommonAttendance('PARTICIPANT', AppLocalizations.of(context)!.eventParticipant),
              buildCommonAttendance('LEADER', AppLocalizations.of(context)!.eventLeader),
              buildCommonAttendance('SUPPORTER', AppLocalizations.of(context)!.eventSupporter),
              buildCommonAttendance('SPECTATOR', AppLocalizations.of(context)!.eventSpectator),
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
          Divider(),
          SectionToggle(
            title: AppLocalizations.of(context)!.labelPersonalAttendence,
            children: [
              InfoSection(icon: Icon(Icons.castle_outlined), title: AppLocalizations.of(context)!.eventOwner),
              AppInfoRow(
                info: AppLocalizations.of(context)!.eventOwner,
                child: ListTile(
                  title: Text(
                      _ownership ? AppLocalizations.of(context)!.labelTrue : AppLocalizations.of(context)!.labelFalse),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => useAppDialog<Valence>(
                      context: context,
                      widget: ChoiceEdit(
                        value: Valence.fromBool(_ownership),
                        nullable: false,
                      ),
                      onChanged: (Valence v) {
                        setState(() => _ownership = v.toBool()!);
                        _handleOwnerSelf(_ownership);
                      },
                    ),
                  ),
                ),
              ),
              ...buildPersonalAttendance('PARTICIPANT', AppLocalizations.of(context)!.eventParticipant),
              ...buildPersonalAttendance('LEADER', AppLocalizations.of(context)!.eventLeader),
              ...buildPersonalAttendance('SUPPORTER', AppLocalizations.of(context)!.eventSupporter),
              ...buildPersonalAttendance('SPECTATOR', AppLocalizations.of(context)!.eventSpectator),
            ],
          )
        ],
      ),
    );
  }

  Widget buildCommonAttendance(String role, String heading) {
    return MenuSection(
      title: heading,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.pageEventAttendancePresences),
          onTap: () => _handleAttendancePresences(role, heading),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.pageEventAttendanceFilters),
          onTap: () => _handleAttendanceFilters(role, heading),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.pageEventAttendanceRegistrations),
          onTap: () => _handleAttendanceRegistrations(role, heading),
        ),
      ],
    );
  }

  List<Widget> buildPersonalAttendance(String role, String heading) {
    return [
      InfoSection(title: heading),
      AppInfoRow(
        info: AppLocalizations.of(context)!.eventRegistration,
        child: ListTile(
          title:
              Text(_attendanceRegistration[role]?.localizedName(context) ?? AppLocalizations.of(context)!.labelMissing),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => useAppDialog<Confirmation?>(
              context: context,
              widget: MultiChoiceEdit<Confirmation>(
                items: Confirmation.values,
                value: _attendanceRegistration[role],
                builder: (confirmation) => confirmation.buildTile(context),
                nullable: true,
              ),
              onChanged: (Confirmation? c) {
                setState(() => _attendanceRegistration[role] = c);
                _handleAttendanceRegistration(role, c);
                _updateAttendanceRegistration(role);
              },
            ),
          ),
        ),
      ),
      AppInfoRow(
        info: AppLocalizations.of(context)!.eventPresence,
        child: ListTile(
          title: Text(_attendancePresence[role]?.localizedName(context) ?? AppLocalizations.of(context)!.labelMissing),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => useAppDialog<Valence>(
              context: context,
              widget: ChoiceEdit(
                value: _attendancePresence[role],
                nullable: false,
              ),
              onChanged: (Valence v) {
                setState(() => _attendancePresence[role] = v);
                _handleAttendancePresence(role, v);
                _updateAttendancePresence(role);
              },
            ),
          ),
        ),
      )
    ];
  }
}
