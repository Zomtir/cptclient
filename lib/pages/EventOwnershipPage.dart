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
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/EventOwnersPage.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/pages/SlotParticipantPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_event_owner.dart' as api_owner;
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventOverviewPage extends StatefulWidget {
  final Session session;

  EventOverviewPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventOverviewPageState();
}

class EventOverviewPageState extends State<EventOverviewPage> {
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: server.cacheLocations);
  final DropdownController<Status> _ctrlStatus = DropdownController<Status>(items: server.cacheSlotStatus);
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Slot> _events = [];

  EventOverviewPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Slot> events = await api_regular.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateEnd.getDate(), _ctrlLocation.value, _ctrlStatus.value);

    setState(() {
      _events = events;
    });
  }

  Future<void> _createEvent() async {
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

  Future<void> _duplicateSlot(Slot slot) async {
    Slot _slot = Slot.fromSlot(slot);
    _slot.status = Status.DRAFT;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: _slot,
          isDraft: true,
          onSubmit: api_regular.event_create,
        ),
      ),
    );

    _update();
  }

  void _handleEventEdit(Slot slot) async {
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

  void _handleEventOwners(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventOwnersPage(
          session: widget.session,
          slot: slot,
        ),
      ),
    );

    _update();
  }

  void _handleEventParticipants(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotParticipantPage(
          session: widget.session,
          slot: slot,
          onCallParticipantList: api_owner.event_participant_list,
          onCallParticipantAdd: api_owner.event_participant_add,
          onCallParticipantRemove: api_owner.event_participant_remove,
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
        title: Text(AppLocalizations.of(context)!.pageEventOwned),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionNew,
            onPressed: _createEvent,
          ),
          FilterToggle(
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotBegin),
                child: DateTimeEdit(controller: _ctrlDateBegin, onUpdate: (date) => _update(), dateOnly: true),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotEnd),
                child: DateTimeEdit(controller: _ctrlDateEnd, onUpdate: (date) => _update(), dateOnly: true),
              ),
              LocationDropdown(
                controller: _ctrlLocation,
                onChanged: _update,
              ),
              StatusDropdown(
                controller: _ctrlStatus,
                onChanged: _update,
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
              return AppSlotTile(
                slot: slot,
                trailing: _buildTrailing(slot),
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildTrailing(Slot slot) {
    switch (slot.status) {
      case Status.DRAFT:
        return [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _handleEventEdit(slot),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _submitSlot(slot),
          ),
          PopupMenuButton<VoidCallback>(
            onSelected: (fn) => fn(),
            itemBuilder: (context) => [
              PopupMenuItem<VoidCallback>(value: () => {}, child: Text('Personal Invites')),
              PopupMenuItem<VoidCallback>(value: () => {}, child: Text('Level Invites')),
              PopupMenuItem<VoidCallback>(value: () => _handleEventParticipants(slot), child: Text('Participants')),
              PopupMenuItem<VoidCallback>(value: () => _handleEventOwners(slot), child: Text('Owners')),
              PopupMenuItem<VoidCallback>(
                value: () => _duplicateSlot(slot),
                child: Row(
                  children: [const Icon(Icons.copy), Text('Duplicate')],
                ),
              ),
            ],
          ),
        ];
      case Status.PENDING:
        return [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => _withdrawSlot(slot),
          )
        ];
      case Status.OCCURRING:
        return [
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: () => _cancelSlot(slot),
          )
        ];
      case Status.REJECTED:
        return [
          IconButton(
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: () => _recycleSlot(slot),
          )
        ];
      case Status.CANCELED:
        return [
          IconButton(
            icon: const Icon(Icons.charging_station),
            onPressed: () => {},
          )
        ];
      default:
        return [];
    }
  }
}
