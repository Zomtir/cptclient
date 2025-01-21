import 'package:cptclient/api/anon/course.dart' as api_anon;
import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:flutter/material.dart';

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
    _load();
  }

  void _load() async {
    List<Course> courses = await api_anon.course_list();
    setState(() => _cache = courses);
  }

  void _loginCourse() async {
    EventSession? session = await server.loginCourse(_ctrlLogin.text);
    if (session == null) return;
    navi.addEventSession(session);
    navi.loginEvent(context, session);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginCourse),
      ),
      body: AppBody(children: [
        TextFormField(
          autofocus: true,
          maxLines: 1,
          controller: _ctrlLogin,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.courseKey,
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
          itemBuilder: (course) => ListTile(
            title: Text(course.title),
            onTap: () => _ctrlLogin.text = course.key,
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
