import 'package:cptclient/api/admin/location/location.dart' as api_admin;
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/widgets/SearchablePanel.dart';
import 'package:cptclient/pages/LocationCreatePage.dart';
import 'package:cptclient/pages/LocationDetailPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class LocationOverviewPage extends StatefulWidget {
  final UserSession session;

  LocationOverviewPage({super.key, required this.session});

  @override
  LocationOverviewPageState createState() => LocationOverviewPageState();
}

class LocationOverviewPageState extends State<LocationOverviewPage> {
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    Result<List<Location>> result_locations = await api_admin.location_list(widget.session);
    if (result_locations is! Success) return;
    setState(() {
      _locations = result_locations.unwrap();
    });
  }

  void _handleSelect(Location location) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(
          session: widget.session,
          location: location,
        ),
      ),
    );

    _update();
  }

  void _handleCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationCreatePage(
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
            items: _locations,
            onTap: _handleSelect,
          )
        ],
      ),
    );
  }
}
