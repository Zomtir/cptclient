import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:cptclient/pages/EventEditPage.dart';
import 'package:cptclient/static/server_event_owner.dart' as api_owner;
import 'package:cptclient/static/server_user_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventDetailOwnershipPage extends StatefulWidget {
  final Session session;
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

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipants,
          tile: AppEventTile(event: event!),
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_owner.event_participant_list(session, event!),
          onCallAdd: (session, user) => api_owner.event_participant_add(session, event!, user),
          onCallRemove: (session, user) => api_owner.event_participant_remove(session, event!, user),
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
          onCallAvailable: (session) => api_regular.user_list(session),
          onCallSelected: (session) => api_owner.event_owner_list(session, event!),
          onCallAdd: (session, user) => api_owner.event_owner_add(session, event!, user),
          onCallRemove: (session, user) => api_owner.event_owner_remove(session, event!, user),
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
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventParticipantRegistration,
            child: Checkbox(
              value: false,
              onChanged: (bool? value) {  },
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventParticipantConfirmation,
            child: Checkbox(
              value: false,
              onChanged: (bool? value) {  },
            ),
          ),
          /*
          AppButton(
            text: AppLocalizations.of(context)!.pageEventRegistrants,
            onPressed: _handleRegistrants,
          ),
          */
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
