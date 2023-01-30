import 'package:flutter/material.dart';
import 'AppTile.dart';

import 'package:cptclient/json/course.dart';

class AppCourseTile extends StatelessWidget {
  final Course course;
  final Function(Course)? onTap;

  const AppCourseTile({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTile<Course>(
      onTap: onTap,
      item: course,
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
