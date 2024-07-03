import 'package:cptclient/json/course.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppCourseTile extends StatelessWidget {
  final Course course;
  final List<Widget> trailing;

  const AppCourseTile({
    super.key,
    required this.course,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "${course.key}", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${course.title}", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
