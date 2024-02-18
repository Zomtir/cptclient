import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/pages/SlotOwnerPage.dart';
import 'package:cptclient/pages/SlotParticipantPage.dart';
import 'package:cptclient/static/server_event_owner.dart' as api_owner;
import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final Session session;
  final int slotID;
  
  EventDetailPage({super.key, required this.session, required this.slotID});

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  Slot? slot;

  EventDetailPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  _update() async {
    Slot? slot = await api_owner.event_info(widget.session, widget.slotID);

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
          onSubmit: api_owner.event_edit,
        ),
      ),
    );

    _update();
  }

  _handleDelete() async {
    if(!await api_owner.event_delete(widget.session, slot!)) return;

    Navigator.pop(context);
  }

  Future<void> _handleParticipants() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotParticipantPage(
          session: widget.session,
          slot: slot!,
          onCallParticipantList: api_owner.event_participant_list,
          onCallParticipantAdd: api_owner.event_participant_add,
          onCallParticipantRemove: api_owner.event_participant_remove,
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
          onCallOwnerList: api_owner.event_owner_list,
          onCallOwnerAdd: api_owner.event_owner_add,
          onCallOwnerRemove: api_owner.event_owner_remove,
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
          //Text(widget.slot.status!.toString()),
          Column(
            children: [
              AppInfoRow(
                info: Text("Register"),
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {  },
                ),
              ),
              AppInfoRow(
                info: Text("Participate"),
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
