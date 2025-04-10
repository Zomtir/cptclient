import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/UserCreatePage.dart';
import 'package:cptclient/pages/UserInfoPage.dart';
import 'package:flutter/material.dart';

class UserOverviewPage extends StatefulWidget {
  final UserSession session;

  UserOverviewPage({super.key, required this.session});

  @override
  UserOverviewPageState createState() => UserOverviewPageState();
}

class UserOverviewPageState extends State<UserOverviewPage> {
  GlobalKey<SearchablePanelState<User>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<User> users = await api_admin.user_list(widget.session);
    searchPanelKey.currentState?.setItems(users);
  }

  void _handleSelect(User user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(
          session: widget.session,
          userID: user.id,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserCreatePage(
          session: widget.session,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageUserManagement),
      ),
      body: AppBody(
        children: <Widget>[
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
          SearchablePanel(
            key: searchPanelKey,
            builder: (User user, Function(User)? onSelect) => InkWell(
              onTap: () => onSelect?.call(user),
              child: user.buildTile(context),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
