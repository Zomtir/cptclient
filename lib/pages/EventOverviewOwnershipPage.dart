import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/FilterToggle.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';
import 'package:cptclient/material/dropdowns/StatusDropdown.dart';
import 'package:cptclient/material/pages/UserSelectionPage.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_event_owner.dart' as api_owner;
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventOverviewOwnershipPage extends StatefulWidget {
  final Session session;

  EventOverviewOwnershipPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewOwnershipPageState();
}

class EventOverviewOwnershipPageState extends State<EventOverviewOwnershipPage> {
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: server.cacheLocations);
  final DropdownController<Status> _ctrlStatus = DropdownController<Status>(items: server.cacheSlotStatus);
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Slot> _events = [];

  EventOverviewOwnershipPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Slot> events = await api_owner.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateEnd.getDate(), _ctrlStatus.value, _ctrlLocation.value);

    setState(() {
      _events = events;
    });
  }

  Future<void> _handleCreate() async {
    Slot slot = Slot.fromUser(widget.session.user!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: slot,
          isDraft: true,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  Future<void> _handleDuplicate(Slot slot) async {
    Slot newSlot = Slot.fromSlot(slot);
    newSlot.status = Status.DRAFT;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: newSlot,
          isDraft: true,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  void _handleSelect(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoPage(
          session: widget.session,
          slot: slot,
        ),
      ),
    );

    _update();
  }

  void _handleEdit(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: slot,
          isDraft: false,
          onSubmit: api_owner.event_edit,
          onPasswordChange: api_owner.event_edit_password,
          onDelete: api_owner.event_delete,
        ),
      ),
    );

    _update();
  }

  void _handleOwners(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectionPage(
          session: widget.session,
          slot: slot,
          title: AppLocalizations.of(context)!.pageEventOwners,
          onCallList: api_owner.event_participant_list,
          onCallAdd: api_owner.event_participant_add,
          onCallRemove: api_owner.event_participant_remove,
        ),
      ),
    );

    _update();
  }

  void _handleParticipants(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectionPage(
          session: widget.session,
          slot: slot,
          title: AppLocalizations.of(context)!.pageEventParticipants,
          onCallList: api_owner.event_participant_list,
          onCallAdd: api_owner.event_participant_add,
          onCallRemove: api_owner.event_participant_remove,
        ),
      ),
    );

    _update();
  }

  Future<void> _submitSlot(Slot slot) async {
    if (!await api_owner.event_submit(widget.session, slot)) return;

    _update();
  }

  Future<void> _withdrawSlot(Slot slot) async {
    if (!await api_owner.event_withdraw(widget.session, slot)) return;

    _update();
  }

  Future<void> _cancelSlot(Slot slot) async {
    if (!await api_owner.event_cancel(widget.session, slot)) return;

    _update();
  }

  Future<void> _recycleSlot(Slot slot) async {
    if (!await api_owner.event_recycle(widget.session, slot)) {
      return;
    }

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventOwnership),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotBegin),
                child: DateTimeEdit(controller: _ctrlDateBegin, showTime: false),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotEnd),
                child: DateTimeEdit(controller: _ctrlDateEnd, showTime: false),
              ),
              LocationDropdown(
                controller: _ctrlLocation,
              ),
              StatusDropdown(
                controller: _ctrlStatus,
              ),
              AppInfoRow(
                info: Text("Show Courses"),
                child: Text("all/yes/no"),
              ),
            ],
          ),
          AppListView(
            items: _events,
            itemBuilder: (Slot slot) {
              return InkWell(
                onTap: () => _handleSelect(slot),
                child: AppSlotTile(
                  slot: slot,
                  trailing: _buildTrailing(slot),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Slot slot) {
    return [
      if (slot.status == Status.DRAFT) IconButton(
        icon: const Icon(Icons.check),
        onPressed: () => _submitSlot(slot),
      ),
      if (slot.status == Status.PENDING) IconButton(
        icon: const Icon(Icons.undo),
        onPressed: () => _withdrawSlot(slot),
      ),
      if (slot.status == Status.OCCURRING) IconButton(
        icon: const Icon(Icons.cancel_outlined),
        onPressed: () => _cancelSlot(slot),
      ),
      if (slot.status == Status.REJECTED) IconButton(
        icon: const Icon(Icons.restore),
        onPressed: () => _recycleSlot(slot),
      ),
      if (slot.status == Status.CANCELED) IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () => {},
      ),
      PopupMenuButton<VoidCallback>(
        onSelected: (fn) => fn(),
        itemBuilder: (context) => [
          if (slot.status == Status.DRAFT) PopupMenuItem<VoidCallback>(
            value: () => _handleEdit(slot),
            child: Text(AppLocalizations.of(context)!.actionEdit),
          ),
          PopupMenuItem<VoidCallback>(
            value: () => _handleDuplicate(slot),
            child: Text(AppLocalizations.of(context)!.actionDuplicate),
          ),
        ],
      ),
    ];
  }
}
