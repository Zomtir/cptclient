import 'dart:convert';

import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseModeratorPage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final bool isDraft;

  CourseModeratorPage({super.key, required this.session, required this.course, required this.isDraft});

  @override
  CourseModeratorPageState createState() => CourseModeratorPageState();
}

class CourseModeratorPageState extends State<CourseModeratorPage> {
  List<User> _moderators = [];

  CourseModeratorPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _getCourseModerators();
  }

  Future<void> _getCourseModerators() async {
    final response = await http.get(
      server.uri('course_moderator_list', {'course_id': widget.course.id.toString()}),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable list = json.decode(utf8.decode(response.bodyBytes));

    setState(() {
      _moderators = List<User>.from(list.map((model) => User.fromJson(model)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Moderators"),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          AppListView<User>(
            items: _moderators,
            itemBuilder: (User user) {
              return InkWell(
                child: ListTile(
                  title: Text("${user.lastname}, ${user.firstname}"),
                  subtitle: Text(user.key),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
