import 'package:flutter/material.dart';
import 'json/member.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppButton.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UserDetailPage.dart';

import 'material/app/AppListView.dart';
import 'material/app/AppMemberTile.dart';
import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/user.dart';

class UserOverviewPage extends StatefulWidget {
  final Session session;

  UserOverviewPage({Key? key, required this.session}) : super(key: key);

  @override
  UserOverviewPageState createState() => UserOverviewPageState();
}

class UserOverviewPageState extends State<UserOverviewPage> {
  List <User> _users = [];

  UserOverviewPageState();

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    final response = await http.get(
      Uri.http(navi.server, 'user_list'),
      headers: {
        'Token': widget.session.token,
        'Accept': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _users = List<User>.from(l.map((model) => User.fromJson(model)));
    });
  }

  void _selectUser(User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailPage(session: widget.session, user: user, onUpdate: _getUsers)));
  }

  void _createUser() async {
    _selectUser(User.fromVoid());
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("User Administration"),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            text: "New user",
            onPressed: _createUser,
          ),
          AppListView(
            items: _users,
            itemBuilder: (User user) {
              return AppMemberTile(
                onTap: (member) => _selectUser(_users.firstWhere((user) => user.id == member.id)),
                item: Member.fromUser(user),
              );
            },
          ),
        ],
      ),
    );
  }



}
