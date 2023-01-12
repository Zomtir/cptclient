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

  List<Widget> buildList(BuildContext context) {
    List<Center> lc = List.generate(_days, (index) {
      return Center(
        child: Text(
          'Day ${index+1}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    });

    List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

    var lc2 = List.generate(7, (index) {
      return Center(
        child: Text(
          '${weekdays[index]}',
        ),
      );
    });

    var lc3 = List.generate(_date!.weekday-1, (index) {
      return Center();
    });

    return lc2+lc3+lc;
  }
}
