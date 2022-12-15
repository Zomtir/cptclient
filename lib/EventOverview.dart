import 'package:flutter/material.dart';
import 'material/PanelSwiper.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppButton.dart';
import 'material/app/AppListView.dart';
import 'material/app/AppSlotTile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EventDetailPage.dart';

import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/slot.dart';

class EventOverview extends StatefulWidget {
  final Session session;

  EventOverview({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventOverviewState();
}

class EventOverviewState extends State<EventOverview> {
  List<Slot> _slotsOccurring = [];
  List<Slot> _slotsDraft = [];
  List<Slot> _slotsPending = [];
  List<Slot> _slotsRejected = [];
  List<Slot> _slotsCanceled = [];

  EventOverviewState();

  @override
  void initState() {
    super.initState();
    _getIndividualSlots();
  }

  Future<void> _getIndividualSlots() async {
    _slotsOccurring = (await _requestIndividualSlots('OCCURRING'))!;
    _slotsDraft = (await _requestIndividualSlots('DRAFT'))!;
    _slotsPending = (await _requestIndividualSlots('PENDING'))!;
    _slotsRejected = (await _requestIndividualSlots('REJECTED'))!;
    _slotsCanceled = (await _requestIndividualSlots('CANCELED'))!;

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

  Future<List<Slot>?> _requestIndividualSlots(String status) async {
    final response = await http.get(
      Uri.http(navi.server, 'event_list', {'status': status}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return null;

    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    return List<Slot>.from(l.map((model) => Slot.fromJson(model)));
  }

  void _createIndividualSlot() async {
    Slot slot = Slot.fromUser(widget.session.user!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          onUpdate: _getIndividualSlots,
          draft: true,
        ),
      ),
    );
  }

  void _selectIndividualSlot(Slot slot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(
          session: widget.session,
          slot: slot,
          onUpdate: _getIndividualSlots,
          draft: false,
        ),
      ),
    );
  }

  Future<void> _submitSlot(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'event_submit', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    switch (response.statusCode) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully submitted slot')));
        _getIndividualSlots();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit slot')));
    }
  }

  Future<void> _withdrawSlot(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'event_withdraw', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    switch (response.statusCode) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully withdrew slot')));
        _getIndividualSlots();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to withdrew slot')));
    }
  }

  Future<void> _cancelSlot(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'event_cancel', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    switch (response.statusCode) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully cancelled slot')));
        _getIndividualSlots();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel slot')));
    }
  }

  Future<void> _recycleSlot(Slot slot) async {
    final response = await http.head(
      Uri.http(navi.server, 'event_recycle', {'slot_id': slot.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    switch (response.statusCode) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully recycled slot')));
        _getIndividualSlots();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to recycle slot')));
    }
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
            onPressed: _createIndividualSlot,
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
