import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/static/datetime.dart';
import 'package:cptclient/static/server_slot_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final Session session;

  CalendarPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  List<Slot> _slotsAll =[];
  final Map<int, List<Slot>> _slotsFiltered = {};
  DateTime _monthFirst = DateTime.now();
  DateTime _monthLast = DateTime.now();

  @override
  void initState() {
    super.initState();
    _setMonth(DateUtils.dateOnly(DateTime.now()));
    _update();
  }

  void _update() async {
    _slotsAll = await api_regular.slot_list(widget.session, _monthFirst, _monthLast);
    _filterSlots();
  }


  void _setMonth(DateTime dt) {
    setState(() {
      _monthFirst = DateTime(dt.year, dt.month, 1);
      _monthLast = DateTime(dt.year, dt.month + 1, 0);
    });

    _update();
  }

  void _filterSlots() {
    setState(() {
      for (int day = 1; day < _monthLast.day; day++) {
        _slotsFiltered[day] =
            filterSlots(_slotsAll, DateTime(_monthFirst.year, _monthFirst.month, day));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () =>
                      _setMonth(DateTime(_monthFirst.year, _monthFirst.month - 1)),
                  icon: Icon(Icons.chevron_left)),
              IconButton(
                  onPressed: () =>
                      _setMonth(DateUtils.dateOnly(DateTime.now())),
                  icon: Icon(Icons.home)),
              Text(DateFormat("yyyy-MM").format(_monthFirst)),
              IconButton(
                  onPressed: () =>
                      _setMonth(DateTime(_monthFirst.year, _monthFirst.month + 1)),
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
          Row(
            children: buildHeader(context),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: buildGrid(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildHeader(BuildContext context) {
    List<String> weekdays = getWeekdaysShort(context);
    return List.generate(7, (index) {
      return Expanded(
        child: Text(
          '${weekdays[index]}',
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  List<Widget> buildGrid(BuildContext context) {
    List<Widget> lc = List.generate(_monthLast.day, (index) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            ...buildDay(context, index + 1),
          ],
        ),
      );
    });

    List<Widget> spacer = List.generate(_monthFirst.weekday - 1, (index) {
      return Container();
    });

    return spacer + lc;
  }

  List<Widget> buildDay(BuildContext context, int day) {
    return List.generate(_slotsFiltered[day]?.length ?? 0, (index) {
      return Container(
        child: Text(
          _slotsFiltered[day]![index].title,
          style: Theme.of(context).textTheme.labelSmall,
          maxLines: 1,
          softWrap: false,
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    });
  }
}
