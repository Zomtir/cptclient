import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/DateTimeController.dart';
import 'package:cptclient/material/DateTimeEdit.dart';
import 'package:cptclient/material/DropdownController.dart';
import 'package:cptclient/material/dropdowns/LocationDropdown.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SlotCreateBatchPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final bool isDraft;
  final Future<bool> Function(Session, Slot) onSubmit;
  final Future<bool> Function(Session, Slot, String)? onPasswordChange;
  final Future<bool> Function(Session, Slot)? onDelete;

  SlotCreateBatchPage({
    super.key,
    required this.session,
    required this.slot,
    required this.isDraft,
    required this.onSubmit,
    this.onPasswordChange,
    this.onDelete,
  });

  @override
  SlotCreateBatchPageState createState() => SlotCreateBatchPageState();
}

class SlotCreateBatchPageState extends State<SlotCreateBatchPage> {
  final DateTimeController _ctrlSlotBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlSlotEnd = DateTimeController(dateTime: DateTime.now().add(Duration(hours: 1)));
  final TextEditingController _ctrlSlotTitle = TextEditingController();
  final DropdownController<Location> _ctrlSlotLocation = DropdownController<Location>(items: server.cacheLocations);
  bool _ctrlSlotPublic = false;
  bool _ctrlSlotScrutable = true;

  final List<bool> _ctrlBatchDays = List<bool>.filled(7, false);
  final DateTimeController _ctrlBatchBegin = DateTimeController(dateTime: DateTime.now());
  final DateTimeController _ctrlBatchEnd = DateTimeController(dateTime: DateTime.now().add(Duration(days: 7)));

  SlotCreateBatchPageState();

  @override
  void initState() {
    super.initState();

    _applySlot();
  }

  void _applySlot() {
    _ctrlSlotBegin.setDateTime(widget.slot.begin);
    _ctrlSlotEnd.setDateTime(widget.slot.end);
    _ctrlSlotTitle.text = widget.slot.title;
    _ctrlSlotLocation.value = widget.slot.location;
    _ctrlSlotPublic = widget.slot.public;
    _ctrlSlotScrutable = widget.slot.scrutable;
  }

  void _gatherSlot() {
    widget.slot.location = _ctrlSlotLocation.value;
    widget.slot.begin = _ctrlSlotBegin.getDateTime()!;
    widget.slot.end = _ctrlSlotEnd.getDateTime()!;
    widget.slot.title = _ctrlSlotTitle.text;
    widget.slot.public = _ctrlSlotPublic;
    widget.slot.scrutable = _ctrlSlotScrutable;
  }

  void _handleSubmit() async {
    _gatherSlot();

    if (widget.slot.location == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location is required.')));
      return;
    }

    List<DateTime> dates = _getFilteredDates();
    for (DateTime date in dates) {
      Slot slot = Slot.fromSlot(widget.slot);
      slot.begin = slot.begin.applyDate(date);
      slot.end = slot.end.applyDate(date);

      if (!await widget.onSubmit(widget.session, slot)) return;
    }

    Navigator.pop(context);
  }

  List<DateTime> _getFilteredDates() {
    List<DateTime> dates = [];
    DateTime startDate = _ctrlBatchBegin.getDate();
    DateTime endDate = _ctrlBatchEnd.getDate();

    if (endDate.isBefore(startDate)) return [];

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      // If the weekday is included, add the date
      if (_ctrlBatchDays[currentDate.weekday - 1]) {
        dates.add(currentDate);
      }

      // Move to the next day
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventEdit),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: Text("Title"),
            child: TextField(
              maxLines: 1,
              controller: _ctrlSlotTitle,
            ),
          ),
          AppInfoRow(
            info: Text("Start Time"),
            child: DateTimeEdit(
              controller: _ctrlSlotBegin,
              showDate: false,
            ),
          ),
          AppInfoRow(
            info: Text("End Time"),
            child: DateTimeEdit(
              controller: _ctrlSlotEnd,
              showDate: false,
            ),
          ),
          LocationDropdown(
            controller: _ctrlSlotLocation,
            onChanged: () => setState(() => {
                  /* Location has changed */
                }),
          ),
          AppInfoRow(
            info: Text("Public"),
            child: Checkbox(
              value: _ctrlSlotPublic,
              onChanged: (bool? active) => setState(() => _ctrlSlotPublic = active!),
            ),
          ),
          AppInfoRow(
            info: Text("Scrutable"),
            child: Checkbox(
              value: _ctrlSlotScrutable,
              onChanged: (bool? active) => setState(() => _ctrlSlotScrutable = active!),
            ),
          ),
          AppInfoRow(
            info: Text("Weekdays"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildDays(context),
            ),
          ),
          AppInfoRow(
            info: Text("From Date"),
            child: DateTimeEdit(
              controller: _ctrlBatchBegin,
              showTime: false,
            ),
          ),
          AppInfoRow(
            info: Text("To Date"),
            child: DateTimeEdit(
              controller: _ctrlBatchEnd,
              showTime: false,
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDays(BuildContext context) {
    List<String> weekdays = getWeekdaysShort(context);
    return List.generate(7, (index) {
      return Column(
        children: [Text("${weekdays[index]}"), Checkbox(value: _ctrlBatchDays[index], onChanged: (bool? value) => setState(() => _ctrlBatchDays[index] = value!))],
      );
    });
  }
}
