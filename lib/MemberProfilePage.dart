import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'static/crypto.dart' as crypto;

import 'json/session.dart';
import 'json/ranking.dart';

class MemberProfilePage extends StatefulWidget {
  final Session session;

  MemberProfilePage({Key? key, required this.session}) : super(key: key);

  @override
  MemberProfilePageState createState() => MemberProfilePageState();
}

class MemberProfilePageState extends State<MemberProfilePage> {
  List <Ranking> _rankings = [];

  TextEditingController _ctrlUserPassword = TextEditingController();

  MemberProfilePageState();

  @override
  void initState() {
    super.initState();
    _ctrlUserPassword.text = "";
    _getRanking();
  }

  Future<void> _savePassword() async {
    if (_ctrlUserPassword.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kept old password')));
      return;
    }

    final response = await http.post(
      Uri.http(navi.server, 'user_password'),
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Token': widget.session.token,
      },
      body: crypto.hashPassword(_ctrlUserPassword.text, widget.session.user!.key),
    );

    if (response.statusCode != 200) return;

    widget.session.user!.pwd = _ctrlUserPassword.text;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully changed password')));
  }

  Future<void> _getRanking() async {
    final response = await http.get(
      Uri.http(navi.server, 'user_info_rankings'),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    Iterable l = json.decode(response.body);

    setState(() {
      _rankings = List<Ranking>.from(l.map((model) => Ranking.fromJson(model)));
    });
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
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          Text("Rankings"),
          _buildRankingList()
        ],
      ),
    );
  }

  ListView _buildRankingList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _rankings.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Container(
            child: ListTile(
              title: Text("${_rankings[index].branch!.title}: ${_rankings[index].rank}"),
              subtitle: Text("${_rankings[index].date} by ${_rankings[index].judge!.key}"),
            ),
          ),
        );
      },
    );
  }

}
