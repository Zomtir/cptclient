import 'package:cptclient/api/regular/event/event.dart' as api_regular;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/occurrence.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/pages/CalendarDayPage.dart';
import 'package:cptclient/pages/EventDetailRegularPage.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarMonthPage extends StatefulWidget {
  final UserSession session;

  CalendarMonthPage({super.key, required this.session});

  @override
  State<StatefulWidget> createState() => CalendarMonthPageState();
}

class CalendarMonthPageState extends State<CalendarMonthPage> {
  List<Event> _eventsAll = [];
  final Map<int, List<Event>> _eventsFiltered = {};
  DateTime _monthFirst = DateTime.now();
  DateTime _monthLast = DateTime.now();
  int _monthDays = 0;

  @override
  void initState() {
    super.initState();
    _setMonth(DateUtils.dateOnly(DateTime.now()));
  }

  void _update() async {
    _eventsAll = await api_regular.event_list(widget.session, begin: _monthFirst, end: _monthLast);
    _filterEvents();
  }

  void _setMonth(DateTime dt) {
    setState(() {
      _monthFirst = DateTime(dt.year, dt.month, 1);
      _monthLast = DateTime(dt.year, dt.month + 1, 1);
      _monthDays = DateTime(dt.year, dt.month + 1, 0).day;
      _eventsFiltered.clear();
    });

    _update();
  }

  void _filterEvents() {
    for (int day = 1; day <= _monthDays; day++) {
      List<Event> eventsPerDay = filterEvents(
        _eventsAll,
        _monthFirst.copyWith(day: day, hour: 0, minute: 0, second: 0),
        _monthFirst.copyWith(day: day, hour: 24, minute: 0, second: 0),
      );

      if (eventsPerDay.length > 4) {
        eventsPerDay.removeRange(4, eventsPerDay.length);
      }
      setState(() => _eventsFiltered[day] = eventsPerDay);
    }
  }

  Future<void> _handleDay(int day) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarDayPage(
          session: widget.session,
          initialDate: _monthFirst.copyWith(day: day),
        ),
      ),
    );
  }

  Future<void> _handleSelectEvent(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailRegularPage(
          session: widget.session,
          event: event,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCalendarMonth),
      ),
      body: AppBody(
        maxWidth: 720,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => _setMonth(DateTime(_monthFirst.year, _monthFirst.month - 1)),
                  icon: Icon(Icons.chevron_left)),
              IconButton(onPressed: () => _setMonth(DateUtils.dateOnly(DateTime.now())), icon: Icon(Icons.home)),
              Text(DateFormat("yyyy-MM").format(_monthFirst)),
              IconButton(
                  onPressed: () => _setMonth(DateTime(_monthFirst.year, _monthFirst.month + 1)),
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 700,
              height: 650,
              child: Column(
                children: [
                  Row(
                    children: buildHeader(context),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 7,
                      mainAxisSpacing: 5.0,
                      children: buildGrid(context),
                    ),
                  ),
                ],
              ),
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
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    });
  }

  List<Widget> buildGrid(BuildContext context) {
    DateTime now = DateTime.now();
    bool correctMonth = now.isAfter(_monthFirst) && now.isBefore(_monthLast.copyWith(hour: 24));
    List<Widget> lc = List.generate(_monthDays, (index) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
                child:
                CircleAvatar(
                  radius: 10,
                  backgroundColor: (correctMonth && now.day == index +1) ? Colors.blue : null,
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () => _handleDay(index + 1)),
            ...buildDayEvents(context, index + 1),
          ],
        ),
      );
    });

    List<Widget> spacer = List.generate(_monthFirst.weekday - 1, (index) {
      return Container();
    });

    return spacer + lc;
  }

  List<Widget> buildDayEvents(BuildContext context, int day) {
    return List.generate(_eventsFiltered[day]?.length ?? 0, (index) {
      return InkWell(
        onTap: () => _handleSelectEvent(_eventsFiltered[day]![index]),
        child: Container(
          child: Text(
            _eventsFiltered[day]![index].title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                decoration: _eventsFiltered[day]![index].occurrence == Occurrence.canceled
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
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
