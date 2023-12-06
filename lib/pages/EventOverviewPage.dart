import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/dropdowns/StatusDropdown.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';

import '../material/DropdownController.dart';
import '../material/FilterToggle.dart';
import 'EventOwnersPage.dart';
import 'EventEditPage.dart';

import '../static/server.dart' as server;
import '../static/serverEventMember.dart' as server;
import '../static/serverEventOwner.dart' as server;
import '../json/session.dart';
import '../json/slot.dart';
import '../json/location.dart';
import 'EventParticipantsPage.dart';

class EventOverviewPage extends StatefulWidget {
  final Session session;

  EventOverviewPage({Key? key, required this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventOverviewPageState();
}

class EventOverviewPageState extends State<EventOverviewPage> {
  DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: server.cacheLocations);
  DropdownController<Status> _ctrlStatus = DropdownController<Status>(items: server.cacheSlotStatus);
  DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -1)));
  DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Slot> _events = [];

  EventOverviewPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Slot> events = await server.event_list(widget.session, _ctrlDateBegin.getDate(), _ctrlDateEnd.getDate(), _ctrlLocation.value, _ctrlStatus.value);

    setState(() {
      _events = events;
    });
  }

  Future<void> _createEvent() async {
    Slot slot = Slot.fromUser(widget.session.user!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          slot: slot,
          isDraft: true,
        ),
      ),
    );

    _update();
  }

  void _handleEventEdit(Slot slot) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEditPage(
          session: widget.session,
          slot: slot,
          isDraft: false,
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
        builder: (context) => EventParticipantsPage(
          session: widget.session,
          slot: slot,
        ),
      ),
    );

    _update();
  }

  Future<void> _submitSlot(Slot slot) async {
    if (!await server.event_submit(widget.session, slot))
      return;

    _update();
  }

  Future<void> _withdrawSlot(Slot slot) async {
    if (!await server.event_withdraw(widget.session, slot))
      return;

    _update();
  }

  Future<void> _cancelSlot(Slot slot) async {
    if (!await server.event_cancel(widget.session, slot))
      return;

    _update();
  }

  Future<void> _recycleSlot(Slot slot) async {
    if (!await server.event_recycle(widget.session, slot)) {
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
