import 'package:flutter/material.dart';
import '../RoundBox.dart';

import 'package:cptclient/json/course.dart';

class AppCourseTile extends StatelessWidget {
  final Course course;

  const AppCourseTile({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${course.key}", child: Icon(Icons.info)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${course.title}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Requires level ${course.branch!.key} ${course.threshold}"),
            ],
          ),
        ],
      ),
    );
  }
}
