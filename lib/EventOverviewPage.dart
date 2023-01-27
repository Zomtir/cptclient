import 'package:flutter/material.dart';
import 'package:cptclient/material/PanelSwiper.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';

import 'EventDetailPage.dart';

import 'static/serverEventMember.dart' as server;
import 'static/serverEventOwner.dart' as server;
import 'json/session.dart';
import 'json/slot.dart';

class EventOverviewPage extends StatefulWidget {
  final Session session;

  EventOverviewPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventOverviewPageState();
}

class EventOverviewPageState extends State<EventOverviewPage> {
  List<Slot> _slotsOccurring = [];
  List<Slot> _slotsDraft = [];
  List<Slot> _slotsPending = [];
  List<Slot> _slotsRejected = [];
  List<Slot> _slotsCanceled = [];

  EventOverviewPageState();

  @override
  void initState() {
    super.initState();
    _getIndividualSlots();
  }

  Future<void> _getIndividualSlots() async {
    _slotsOccurring = await server.event_list(widget.session, 'OCCURRING');
    _slotsDraft = await server.event_list(widget.session, 'DRAFT');
    _slotsPending = await server.event_list(widget.session, 'PENDING');
    _slotsRejected = await server.event_list(widget.session, 'REJECTED');
    _slotsCanceled = await server.event_list(widget.session, 'CANCELED');

    /* This "bad" practice.
     * Ideally the assignment should be inside the setState function
     * but await inside setState is not possible. Alternatively four temp list
     * could be created to fill the slot lists and then assign them to the real
     * variable in the setState. But this seems overkill.
     * The only drawback of this solution is that a different unrelated setState
     * callback might refresh the page and draw an intermediate state of the lists,
     * which wouldn't be drastic either.
     */
    setState(() {});
  }

  void _createEvent() async {
    Slot slot = Slot.fromUser(widget.session.user!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          onUpdate: _getIndividualSlots,
          isDraft: true,
          isOwner: true,
          isAdmin: false,
        ),
      ),
    );
  }

  void _selectIndividualSlot(Slot slot) async {
    bool isOwner = await server.event_owner_condition(widget.session, slot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          onUpdate: _getIndividualSlots,
          isDraft: false,
          isOwner: isOwner,
          isAdmin: false,
        ),
      ),
    );
  }

  Future<void> _submitSlot(Slot slot) async {
    if (!await server.event_submit(widget.session, slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit slot')));
      return;
    }

    _getIndividualSlots();
  }

  Future<void> _withdrawSlot(Slot slot) async {
    if (!await server.event_withdraw(widget.session, slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to withdraw slot')));
      return;
    }

    _getIndividualSlots();
  }

  Future<void> _cancelSlot(Slot slot) async {
    if (!await server.event_cancel(widget.session, slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel slot')));
      return;
    }

    _getIndividualSlots();
  }

  Future<void> _recycleSlot(Slot slot) async {
    if (!await server.event_recycle(widget.session, slot)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to recycle slot')));
      return;
    }

    _getIndividualSlots();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Your Events"),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: "Draft new slot",
            onPressed: _createEvent,
          ),
          PanelSwiper(swipes: 0, panels: [
            Panel("Draft", _buildDraftSlotPanel()),
            Panel("Pending", _buildPendingSlotPanel()),
            Panel("Occurring", _buildOccurringSlotPanel()),
            Panel("Rejected", _buildRejectedSlotPanel()),
            Panel("Canceled", _buildCanceledSlotPanel()),
          ]),
        ],
      ),
    );
  }

  Widget _buildDraftSlotPanel() {
    return AppListView(
      items: _slotsDraft,
      itemBuilder: (Slot slot) {
        return Row(
          children: [
            Expanded(
              child: AppSlotTile(
                onTap: _selectIndividualSlot,
                slot: slot,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _submitSlot(slot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOccurringSlotPanel() {
    return AppListView(
      items: _slotsOccurring,
      itemBuilder: (Slot slot) {
        return Row(
          children: [
            Expanded(
              child: AppSlotTile(
                onTap: _selectIndividualSlot,
                slot: slot,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => _cancelSlot(slot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingSlotPanel() {
    return AppListView(
      items: _slotsPending,
      itemBuilder: (Slot slot) {
        return Row(
          children: [
            Expanded(
              child: AppSlotTile(
                onTap: _selectIndividualSlot,
                slot: slot,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _withdrawSlot(slot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRejectedSlotPanel() {
    return AppListView(
      items: _slotsRejected,
      itemBuilder: (Slot slot) {
        return Row(
          children: [
            Expanded(
              child: AppSlotTile(
                onTap: _selectIndividualSlot,
                slot: slot,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              onPressed: () => _recycleSlot(slot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCanceledSlotPanel() {
    return AppListView(
      items: _slotsCanceled,
      itemBuilder: (Slot slot) {
        return AppSlotTile(
          onTap: _selectIndividualSlot,
          slot: slot,
        );
      },
    );
  }
}
