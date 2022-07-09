import 'package:cptclient/material/app/AppButton.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {

  DateTime _date = DateTime.now();
  int _days = 0;

  @override
  void initState() {
    _date = DateTime(_date.year, _date.month);
    _scrollMonth(0);
    super.initState();
  }

  void _scrollMonth(int scroll) {
    setState(() {
      _date = DateTime(_date.year, _date.month + scroll);
      _days = DateTime(_date.year, _date.month + 1, 0).day;
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
              AppButton(text: "Before", onPressed: () => _scrollMonth(-1)),
              Text(DateFormat("yyyy-MM").format(_date)),
              AppButton(text: "After", onPressed: () => _scrollMonth(1)),
            ],
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              // Generate 100 widgets that display their index in the List.
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

    var lc3 = List.generate(_date.weekday-1, (index) {
      return Center();
    });



    return lc2+lc3+lc;
  }
}
