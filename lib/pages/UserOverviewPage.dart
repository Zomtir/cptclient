import 'package:cptclient/api/admin/user/user.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
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
    searchPanelKey.currentState?.update(users);
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel(
            key: searchPanelKey,
            onTap: _handleSelect,
          ),
        ],
      ),
    );
  }
}
