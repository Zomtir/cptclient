import 'package:cptclient/json/course.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
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
    return AppTile(
      child: ListTile(
        leading: Tooltip(message: "${course.key}", child: Icon(Icons.info)),
        title: Text("${course.title}"),
      ),
    );
  }
}
