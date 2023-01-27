import 'package:flutter/material.dart';

import 'package:cptclient/json/course.dart';

class AppCourseTile extends StatelessWidget {
  final Course course;
  final Function(Course) onTap;

  const AppCourseTile({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(course),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white60,
          border: Border.all(
            color: Colors.amber,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
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
                Text("${course.access!.title}"),
                Text("Requires level ${course.branch!.key} ${course.threshold}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
