import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';

import "package:universal_html/html.dart";

import '../static/server.dart' as server;
import '../static/navigation.dart' as navi;

import 'ConnectionPage.dart';
import 'CreditPage.dart';

class LoginCoursePage extends StatefulWidget {
  LoginCoursePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginCoursePageState();
}

class LoginCoursePageState extends State<LoginCoursePage> {
  TextEditingController _ctrlCourseLogin = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ctrlCourseLogin.text = window.localStorage['DefaultCourse']!;
  }

  void _loginCourse() async {
    bool success = await server.loginCourse(_ctrlCourseLogin.text);

    _ctrlCourseLogin.text = window.localStorage['DefaultCourse']!;

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
          controller: _ctrlCourseLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "Course Key",
            hintText: "Only alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlCourseLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppButton(
          text: "Login",
          onPressed: _loginCourse,
        ),
        Divider(
          height: 30,
          thickness: 5,
          color: Colors.black,
        ),
      ]),
    );
  }
}
