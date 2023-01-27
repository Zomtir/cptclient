import 'package:flutter/material.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';

import 'static/serverUserMember.dart' as server;

import 'json/session.dart';

class MemberProfilePage extends StatefulWidget {
  final Session session;

  MemberProfilePage({Key? key, required this.session}) : super(key: key);

  @override
  MemberProfilePageState createState() => MemberProfilePageState();
}

class MemberProfilePageState extends State<MemberProfilePage> {
  TextEditingController _ctrlUserPassword = TextEditingController();

  MemberProfilePageState();

  @override
  void initState() {
    super.initState();
    _ctrlUserPassword.text = "";
  }

  Future<void> _savePassword() async {
    if (_ctrlUserPassword.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kept old password')));
      return;
    }

    if (!await server.password_edit(widget.session, _ctrlUserPassword.text)) return;

    widget.session.user!.pwd = _ctrlUserPassword.text;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully changed password')));
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: AppBody(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.perm_identity),
                Tooltip(message: "ID ${widget.session.user!.id}", child: Text("${widget.session.user!.key}", style: TextStyle(fontWeight: FontWeight.bold))),
              ]
          ),
          AppInfoRow(
            info: Text("Name"),
            child: Text("${widget.session.user!.lastname}, ${widget.session.user!.firstname}"),
          ),
          AppInfoRow(
            info: Text("Password"),
            child: TextField(
              obscureText: true,
              maxLines: 1,
              controller: _ctrlUserPassword,
              decoration: InputDecoration(
                hintText: "Change password (leave empty to keep current)",
                suffixIcon: IconButton(
                  onPressed: _savePassword,
                  icon: Icon(Icons.save),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
