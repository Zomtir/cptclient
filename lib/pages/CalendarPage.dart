import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {

  DateTime? _date;
  int _days = 0;

  @override
  void initState() {
    super.initState();
    _resetMonth();
  }

  void _resetMonth() {
    setState(() {
      _date = DateUtils.dateOnly(_date ?? DateTime.now());
      _days = DateTime(_date!.year, _date!.month + 1, 0).day;
    });
  }

  void _scrollMonth(int scroll) {
    setState(() {
      _date = DateTime(_date!.year, _date!.month + scroll);
      _days = DateTime(_date!.year, _date!.month + 1, 0).day;
    });
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => _scrollMonth(-1), icon: Icon(Icons.chevron_left)),
              IconButton(onPressed: _resetMonth, icon: Icon(Icons.home)),
              Text(DateFormat("yyyy-MM").format(_date!)),
              IconButton(onPressed: () => _scrollMonth(-1), icon: Icon(Icons.chevron_right)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildDays(context),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: buildList(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildDays(BuildContext context) {
    List<String> weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return List.generate(7, (index) {
      return Center(
        child: Text(
          '${weekdays[index]}',
        ),
      );
    });
  }

  List<Widget> buildList(BuildContext context) {
    List<Widget> lc = List.generate(_days, (index) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                '${index+1}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Container(
              child: Text("Placeholder",
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                softWrap: false,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Container(
              child: Text("Placeholder",
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                softWrap: false,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
            )
          ],
        ),
      );
    });

    List<Widget> spacer = List.generate(_date!.weekday-1, (index) {
      return Center();
    });

    return spacer+lc;
  }
}
