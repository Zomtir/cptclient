import 'package:cptclient/api/regular/user/user.dart' as server;
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemberProfilePage extends StatefulWidget {
  final UserSession session;

  MemberProfilePage({super.key, required this.session});

  @override
  MemberProfilePageState createState() => MemberProfilePageState();
}

class MemberProfilePageState extends State<MemberProfilePage> {
  final TextEditingController _ctrlUserPassword = TextEditingController();
  List<Permission> _permissions = [];

  MemberProfilePageState();

  @override
  void initState() {
    super.initState();
    _ctrlUserPassword.text = "";
    _permissions = widget.session.right!.toList();
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
        title: Text(AppLocalizations.of(context)!.pageUserProfile),
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
            info: AppLocalizations.of(context)!.user,
            child: widget.session.user!.buildEntry(),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: TextField(
              obscureText: true,
              maxLines: 1,
              controller: _ctrlUserPassword,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.userPasswordChange,
                suffixIcon: IconButton(
                  onPressed: _savePassword,
                  icon: Icon(Icons.save),
                ),
              ),
            ),
          ),
          Divider(),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.labelPermission)),
              DataColumn(label: Text(AppLocalizations.of(context)!.actionRead)),
              DataColumn(label: Text(AppLocalizations.of(context)!.actionWrite)),
            ],
            rows: List<DataRow>.generate(_permissions.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(Right.localeList(context)[index])),
                  DataCell(
                    Checkbox(
                      value: _permissions[index].read,
                      onChanged: null,
                    ),
                  ),
                  DataCell(
                    Checkbox(
                      value: _permissions[index].write,
                      onChanged: null,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

}
