import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CalendarDayPage extends StatefulWidget {
  final UserSession session;
  final DateTime initialDate;

  CalendarDayPage(
      {super.key, required this.session, required this.initialDate});

  @override
  State<StatefulWidget> createState() => CalendarDayPageState();
}

class CalendarDayPageState extends State<CalendarDayPage> {
  List<Event> _eventsAll = [];
  List<Event> _eventsFiltered = [];
  DateTime _dayFirst = DateTime(0);
  DateTime _dayLast = DateTime(0);

  @override
  void initState() {
    super.initState();
    _setDay(widget.initialDate);
    _update();
  }

  void _update() async {
    _eventsAll =
        await api_regular.event_list(widget.session, begin: _dayFirst, end: _dayLast);
    _filterEvents();
  }

  void _setDay(DateTime dt) {
    setState(() {
      _dayFirst = dt.copyWith(hour: 0);
      _dayLast = dt.copyWith(hour: 24);
      _eventsFiltered.clear();
    });

    _update();
  }

  void _filterEvents() {
    setState(() {
      _eventsFiltered = filterEvents(_eventsAll, _dayFirst, _dayLast);
    });
  }

  Future<void> _handleSelectEvent(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoPage(
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
        title: Text(AppLocalizations.of(context)!.pageCalendarDay),
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
    return List.generate(_eventsFiltered.length, (index) {
      return Card(
        child: ListTile(
          title: Text(_eventsFiltered[index].title),
          onTap: () => _handleSelectEvent(_eventsFiltered[index]),
        ),
      );
    });
  }
}
