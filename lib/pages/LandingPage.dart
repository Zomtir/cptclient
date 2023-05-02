import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';

import "package:universal_html/html.dart";

import '../static/server.dart' as server;
import '../static/navigation.dart' as navi;

import 'ConnectionPage.dart';
import 'CreditPage.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  TextEditingController _ctrlUserLogin = TextEditingController();
  TextEditingController _ctrlUserPasswd = TextEditingController();
  TextEditingController _ctrlSlotLogin = TextEditingController();
  TextEditingController _ctrlSlotPasswd = TextEditingController();
  TextEditingController _ctrlCourseLogin = TextEditingController();
  TextEditingController _ctrlLocationLogin = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ctrlUserLogin.text = window.localStorage['DefaultUser']!;
    _ctrlSlotLogin.text = window.localStorage['DefaultSlot']!;
    _ctrlCourseLogin.text = window.localStorage['DefaultCourse']!;
    _ctrlLocationLogin.text = window.localStorage['DefaultLocation']!;
  }

  void _resume() async {
    switch (window.localStorage['Session']!) {
      case 'user':
        navi.loginUser();
        break;
      case 'slot':
        navi.loginSlot();
        break;
      default:
        break;
    }
  }

  void _loginUser() async {
    bool success = await server.loginUser(_ctrlUserLogin.text, _ctrlUserPasswd.text);

    _ctrlUserLogin.text = window.localStorage['DefaultUser']!;
    _ctrlUserPasswd.text = "";

    if (success) navi.loginUser();
  }

  void _loginSlot() async {
    bool success = await server.loginSlot(_ctrlSlotLogin.text, _ctrlSlotPasswd.text);

    _ctrlSlotLogin.text = window.localStorage['DefaultSlot']!;
    _ctrlSlotPasswd.text = "";

    if (success) navi.loginSlot();
  }

  void _loginCourse() async {
    bool success = await server.loginCourse(_ctrlCourseLogin.text);

    _ctrlCourseLogin.text = window.localStorage['DefaultCourse']!;

    if (success) navi.loginSlot();
  }

  void _loginLocation() async {
    bool success = await server.loginLocation(_ctrlLocationLogin.text);

    _ctrlLocationLogin.text = window.localStorage['DefaultLocation']!;

    if (success) navi.loginSlot();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Participation Tracker"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionPage())),
          ),
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditPage())),
          ),
        ],
      ),
      body: AppBody(children: [
        if (window.localStorage['Session']!.isNotEmpty) AppButton(
          text: "Resume Session",
          onPressed: _resume,
        ),
        if (window.localStorage['Session']!.isNotEmpty) Divider(
          height: 30,
          thickness: 5,
          color: Colors.black,
        ),
        TextField(
          maxLines: 1,
          controller: _ctrlUserLogin,
          autofillHints: const <String>[AutofillHints.username],
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "User Key",
            hintText: "6 alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlUserLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        TextField(
          autofocus: true,
          obscureText: true,
          maxLines: 1,
          controller: _ctrlUserPasswd,
          autofillHints: const <String>[AutofillHints.password],
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "User password",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlUserPasswd.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppButton(
          text: "User Login",
          onPressed: _loginUser,
        ),
        Divider(
          height: 30,
          thickness: 5,
          color: Colors.black,
        ),
        TextFormField(
          maxLines: 1,
          controller: _ctrlSlotLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "Slot Key",
            hintText: "8 alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlSlotLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        TextField(
          obscureText: true,
          maxLines: 1,
          controller: _ctrlSlotPasswd,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "Slot Password",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlSlotPasswd.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppButton(
          text: "Slot Login",
          onPressed: _loginSlot,
        ),
        Divider(
          height: 30,
          thickness: 5,
          color: Colors.black,
        ),
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
          text: "Course Login",
          onPressed: _loginCourse,
        ),
        Divider(
          height: 30,
          thickness: 5,
          color: Colors.black,
        ),
        TextFormField(
          autofocus: true,
          maxLines: 1,
          controller: _ctrlLocationLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: "Location Key",
            hintText: "Only alphanumeric characters",
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              onPressed: () => _ctrlLocationLogin.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        AppButton(
          text: "Location Login",
          onPressed: _loginLocation,
        ),
      ]),
    );
  }
}
