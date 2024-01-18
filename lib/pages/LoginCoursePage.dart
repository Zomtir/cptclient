import 'package:cptclient/json/course.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/design/AppButtonLightStyle.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart' as server;
import 'package:flutter/material.dart';
import 'dart:html';

class LoginCoursePage extends StatefulWidget {
  LoginCoursePage({super.key});

  @override
  State<StatefulWidget> createState() => LoginCoursePageState();
}

class LoginCoursePageState extends State<LoginCoursePage> {
  final TextEditingController _ctrlLogin = TextEditingController();
  List<Course> _cache = [];

  @override
  void initState() {
    super.initState();

    _ctrlLogin.text = window.localStorage['DefaultCourse']!;
    _cache = [];
    _load();
  }

  void _load() async {
    List<Course> courses = await server.receiveCourses();
    setState(() => _cache = courses);
  }

  void _loginCourse() async {
    bool success = await server.loginCourse(_ctrlLogin.text);

    _ctrlLogin.text = window.localStorage['DefaultCourse']!;

    if (success) navi.loginSlot();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Login"),
      ),
      body: AppBody(children: [
        TextFormField(
          autofocus: true,
          maxLines: 1,
          controller: _ctrlLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "Course Key",
            hintText: "Only alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppListView(
          items: _cache,
          itemBuilder: (course) => AppButton(
            text: course.title,
            onPressed: () => _ctrlLogin.text = course.key,
            style: AppButtonLightStyle(),
          ),
        ),
        AppButton(
          text: "Login",
          onPressed: _loginCourse,
        ),
      ]),
    );
  }
}
