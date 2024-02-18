import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/pages/SlotOwnerPage.dart';
import 'package:cptclient/pages/SlotParticipantPage.dart';
import 'package:cptclient/static/server_class_admin.dart' as api_admin;
import 'package:flutter/material.dart';

class ClassDetailPage extends StatefulWidget {
  final Session session;
  final int slotID;
  
  ClassDetailPage({super.key, required this.session, required this.slotID});

  @override
  ClassDetailPageState createState() => ClassDetailPageState();
}

class ClassDetailPageState extends State<ClassDetailPage> {
  Slot? slot;

  ClassDetailPageState();

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
        builder: (context) => SlotParticipantPage(
          session: widget.session,
          slot: slot!,
          onCallParticipantList: api_admin.class_participant_list,
          onCallParticipantAdd: api_admin.class_participant_add,
          onCallParticipantRemove: api_admin.class_participant_remove,
        ),
      ),
    );
  }

  Future<void> _handleOwners() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotOwnerPage(
          session: widget.session,
          slot: slot!,
          onCallOwnerList: api_admin.class_owner_list,
          onCallOwnerAdd: api_admin.class_owner_add,
          onCallOwnerRemove: api_admin.class_owner_remove,
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
            text: "Participants",
            onPressed: _handleParticipants,
          ),
          AppButton(
            text: "Owners",
            onPressed: _handleOwners,
          ),
        ],
      ),
    );
  }

}
