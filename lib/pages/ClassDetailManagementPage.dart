import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/pages/UserSelectionPage.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/static/server_class_admin.dart' as api_admin;
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
    _update();
  }

  _update() async {
    Slot? slot = await api_admin.class_info(widget.session, widget.slotID);

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
          onSubmit: api_admin.class_edit,
        ),
      ),
    );

    _update();
  }

  _handleDelete() async {
    if(!await api_admin.class_delete(widget.session, slot!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectionPage(
          session: widget.session,
          slot: slot!,
          title: AppLocalizations.of(context)!.pageClassParticipants,
          onCallList: api_admin.class_participant_list,
          onCallAdd: api_admin.class_participant_add,
          onCallRemove: api_admin.class_participant_remove,
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
          slot: slot!,
          title: AppLocalizations.of(context)!.pageClassOwners,
          onCallList: api_admin.class_owner_list,
          onCallAdd: api_admin.class_owner_add,
          onCallRemove: api_admin.class_owner_remove,
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
        title: Text("Slot details"),
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
            text: AppLocalizations.of(context)!.pageClassParticipants,
            onPressed: _handleParticipants,
          ),
          AppButton(
            text: AppLocalizations.of(context)!.pageClassOwners,
            onPressed: _handleOwners,
          ),
        ],
      ),
    );
  }

}
