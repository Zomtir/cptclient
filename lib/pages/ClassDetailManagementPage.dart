import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/SelectionPage.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/tiles/AppUserTile.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassDetailManagementPage extends StatefulWidget {
  final Session session;
  final int slotID;
  
  ClassDetailManagementPage({super.key, required this.session, required this.slotID});

  @override
  ClassDetailManagementPageState createState() => ClassDetailManagementPageState();
}

class ClassDetailManagementPageState extends State<ClassDetailManagementPage> {
  Slot? slot;

  ClassDetailManagementPageState();

  @override
  void initState() {
    super.initState();
    print("hi1");
    _update();
    print("hi2");
  }

  _update() async {
    Slot? slot = await api_admin.event_info(widget.session, widget.slotID);

    if (slot == null) return;

    setState(() {
      this.slot = slot;
    });
  }

  _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: slot!,
          isDraft: false,
          onSubmit: api_admin.event_edit,
        ),
      ),
    );

    _update();
  }

  _handleDelete() async {
    if(!await api_admin.event_delete(widget.session, slot!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage<User>(
          session: widget.session,
          title: AppLocalizations.of(context)!.pageEventParticipants,
          tile: AppSlotTile(slot: slot!),
          onCallAvailable: (session) => api_admin.event_participant_pool(session, slot!),
          onCallSelected: (session) => api_admin.event_participant_list(session, slot!),
          onCallAdd: (session, user) => api_admin.event_participant_add(session, slot!, user),
          onCallRemove: (session, user) => api_admin.event_participant_remove(session, slot!, user),
          filter: filterUsers,
          builder: (User user) => AppUserTile(user: user),
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
          tile: AppSlotTile(slot: slot!),
          onCallAvailable: (session) => api_admin.event_owner_pool(session, slot!),
          onCallSelected: (session) => api_admin.event_owner_list(session, slot!),
          onCallAdd: (session, user) => api_admin.event_owner_add(session, slot!, user),
          onCallRemove: (session, user) => api_admin.event_owner_remove(session, slot!, user),
          filter: filterUsers,
          builder: (User user) => AppUserTile(user: user),
        ),
      ),
    );
  }

  @override
  Widget build (BuildContext context) {
    if (slot == null) {
      return Icon(Icons.downloading);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventDetails),
      ),
      body: AppBody(
        children: [
          AppSlotTile(
            slot: slot!,
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
