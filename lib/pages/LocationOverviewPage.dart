import 'package:cptclient/api/admin/location/location.dart' as api_admin;
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/LocationEditPage.dart';
import 'package:flutter/material.dart';

class LocationOverviewPage extends StatefulWidget {
  final UserSession session;

  LocationOverviewPage({super.key, required this.session});

  @override
  LocationOverviewPageState createState() => LocationOverviewPageState();
}

class LocationOverviewPageState extends State<LocationOverviewPage> {
  GlobalKey<SearchablePanelState<Location>> searchPanelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Location> locations = await api_admin.location_list(widget.session);
    searchPanelKey.currentState?.update(locations);
  }

  void _handleSelect(Location location) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationEditPage(
          session: widget.session,
          location: location,
          isDraft: false,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationEditPage(
          session: widget.session,
          location: Location.fromVoid(),
          isDraft: true,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageLocationManagement),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        children: <Widget>[
          SearchablePanel(
            key: searchPanelKey,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
