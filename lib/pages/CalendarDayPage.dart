import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server_slot_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDayPage extends StatefulWidget {
  final Session session;
  final DateTime initialDate;

  CalendarDayPage(
      {super.key, required this.session, required this.initialDate});

  @override
  State<StatefulWidget> createState() => CalendarDayPageState();
}

class CalendarDayPageState extends State<CalendarDayPage> {
  List<Slot> _slotsAll = [];
  List<Slot> _slotsFiltered = [];
  DateTime _dayFirst = DateTime(0);
  DateTime _dayLast = DateTime(0);

  @override
  void initState() {
    super.initState();
    _setDay(widget.initialDate);
    _update();
  }

  void _update() async {
    _slotsAll =
        await api_regular.slot_list(widget.session, _dayFirst, _dayLast);
    _filterSlots();
  }

  void _setDay(DateTime dt) {
    setState(() {
      _dayFirst = dt.copyWith(hour: 0);
      _dayLast = dt.copyWith(hour: 24);
      _slotsFiltered.clear();
    });

    _update();
  }

  void _filterSlots() {
    setState(() {
      _slotsFiltered = filterSlots(_slotsAll, _dayFirst, _dayLast);
    });
  }

  Future<void> _handleSelectEvent(Slot slot) async {
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
        title: Text("Calendar Day"),
      ),
      body: AppBody(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () =>
                      _setDay(_dayFirst.subtract(Duration(days: 1))),
                  icon: Icon(Icons.chevron_left)),
              IconButton(
                  onPressed: () => _setDay(DateUtils.dateOnly(DateTime.now())),
                  icon: Icon(Icons.home)),
              Text(DateFormat("yyyy-MM-dd").format(_dayFirst)),
              IconButton(
                  onPressed: () => _setDay(_dayFirst.add(Duration(days: 1))),
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
          ...buildDay(context),
        ],
      ),
    );
  }

  List<Widget> buildDay(BuildContext context) {
    return List.generate(_slotsFiltered.length, (index) {
      return InkWell(
        onTap: () => _handleSelectEvent(_slotsFiltered[index]),
        child: Container(
          child: Text(
            _slotsFiltered[index].title,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            softWrap: false,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
    });
  }
}
