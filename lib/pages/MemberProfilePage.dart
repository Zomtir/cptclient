import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/server_user_regular.dart' as server;
import 'package:flutter/material.dart';

class MemberProfilePage extends StatefulWidget {
  final Session session;

  MemberProfilePage({super.key, required this.session});

  @override
  MemberProfilePageState createState() => MemberProfilePageState();
}

class MemberProfilePageState extends State<MemberProfilePage> {
  final TextEditingController _ctrlUserPassword = TextEditingController();

  MemberProfilePageState();

  @override
  void initState() {
    super.initState();
    _ctrlUserPassword.text = "";
  }

  Future<void> _savePassword() async {
    if (!await server.put_password(widget.session, _ctrlUserPassword.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password was not changed.')));
      return;
    }

    _ctrlUserPassword.text = '';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully changed password')));
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
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
