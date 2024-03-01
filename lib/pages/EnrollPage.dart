import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/pages/UserSelectionPage.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server_slot_service.dart' as api_service;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnrollPage extends StatefulWidget {
  final Session session;

  EnrollPage({super.key, required this.session}) {
    if (session.token.isEmpty) navi.logout();
  }

  @override
  State<StatefulWidget> createState() => EnrollPageState();
}

class EnrollPageState extends State<EnrollPage> {
  final TextEditingController _ctrlSlotNote = TextEditingController();
  Slot? _slot;

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    Slot? slot = await api_service.slot_info(widget.session);
    if (slot == null) return;

    setState(() {
      _slot = slot;
      _ctrlSlotNote.text = slot.note;
    });
  }

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectionPage(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageClassParticipants,
          tile: AppSlotTile(slot: _slot!),
          onCallAvailable: (session) => api_service.slot_participant_pool(session),
          onCallSelected: (session) => api_service.slot_participant_list(session),
          onCallAdd: (session, user) => api_service.slot_participant_add(session, user),
          onCallRemove: (session, user) => api_service.slot_participant_remove(session, user),
        ),
      ),
    );
  }

  Future<void> _handleOwners() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectionPage(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageClassOwners,
          tile: AppSlotTile(slot: _slot!),
          onCallAvailable: (session) => api_service.slot_owner_pool(session),
          onCallSelected: (session) => api_service.slot_owner_list(session),
          onCallAdd: (session, user) => api_service.slot_owner_add(session, user),
          onCallRemove: (session, user) => api_service.slot_owner_remove(session, user),
        ),
      ),
    );
  }

  Future<void> _handleNote() async {
    await api_service.slot_note_edit(widget.session, _ctrlSlotNote.text);
  }

  @override
  Widget build(BuildContext context) {
    if (_slot == null) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Participation"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logout(),
          )
        ],
      ),
      body: AppBody(
        children: [
          AppSlotTile(slot: _slot!),
          AppButton(
            text: AppLocalizations.of(context)!.pageClassParticipants,
            onPressed: _handleParticipants,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageClassOwners,
            onPressed: _handleOwners,
          ),
          AppInfoRow(
            info: Text("Notes"),
            child: TextField(
              maxLines: 4,
              controller: _ctrlSlotNote,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.save),
              onPressed: _handleNote,
            ),
          ),
        ],
      ),
    );
  }
}
