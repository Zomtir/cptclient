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
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventAvailablePage extends StatefulWidget {
  final Session session;

  EventAvailablePage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => EventAvailablePageState();
}

class EventAvailablePageState extends State<EventAvailablePage> {
  final DropdownController<Location> _ctrlLocation = DropdownController<Location>(items: server.cacheLocations);
  final DropdownController<Status> _ctrlStatus = DropdownController<Status>(items: server.cacheSlotStatus);
  final DateTimeController _ctrlDateBegin = DateTimeController(dateTime: DateTime.now().add(Duration(days: -7)));
  final DateTimeController _ctrlDateEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 30)));

  List<Slot> _events = [];

  EventAvailablePageState();

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

  void _handleSelectSlot(Slot slot) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventAvailable),
      ),
      body: AppBody(
        children: [
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionNew,
            onPressed: _createEvent,
          ),
          FilterToggle(
            onApply: _update,
            children: [
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotBegin),
                child: DateTimeEdit(controller: _ctrlDateBegin, dateOnly: true),
              ),
              AppInfoRow(
                info: Text(AppLocalizations.of(context)!.slotEnd),
                child: DateTimeEdit(controller: _ctrlDateEnd, dateOnly: true),
              ),
              LocationDropdown(
                controller: _ctrlLocation,
              ),
              StatusDropdown(
                controller: _ctrlStatus,
              ),
            ],
          ),
          AppListView(
            items: _events,
            itemBuilder: (Slot slot) {
              return InkWell(
                onTap: () => _handleSelectSlot(slot),
                child: AppSlotTile(
                  slot: slot,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
