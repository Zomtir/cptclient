import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/credential.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/dialogs/PasswordEditDialog.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class MemberProfilePage extends StatefulWidget {
  final UserSession session;

  MemberProfilePage({super.key, required this.session});

  @override
  MemberProfilePageState createState() => MemberProfilePageState();
}

class MemberProfilePageState extends State<MemberProfilePage> {
  Credential? credential;
  List<Permission> _permissions = [];

  MemberProfilePageState();

  @override
  void initState() {
    super.initState();
    _permissions = widget.session.right!.toList();

    _update();
  }

  void _update() async {
    Result<Credential> credential = await api_regular.user_password_info(widget.session);

    if (credential is Failure) return;

    setState(() {
      this.credential = credential.unwrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.pageUserProfile)),
      body: AppBody(
        children: <Widget>[
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelName,
            child: ListTile(title: Text("${widget.session.user!.firstname} ${widget.session.user!.lastname}")),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userKey,
            child: ListTile(title: Text(widget.session.user!.key)),
          ),

          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: (credential == null)
                ? ListTile(title: Text(AppLocalizations.of(context)!.labelMissing))
                : ListTile(
                    title: credential!.buildInfo(context),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => useAppDialog(
                        context: context,
                        child: PasswordEditDialog(initialValue: credential, onConfirm: (Credential? cr) async {
                          if (cr == null) return;
                          api_regular.user_password_edit(widget.session, cr.password!, cr.salt!);
                          _update();
                        },),

                      ),
                    ),
                  ),
          ),
          Divider(),
          InfoSection(title: AppLocalizations.of(context)!.labelPermission),
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
                  DataCell(Checkbox(value: _permissions[index].read, onChanged: null)),
                  DataCell(Checkbox(value: _permissions[index].write, onChanged: null)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
