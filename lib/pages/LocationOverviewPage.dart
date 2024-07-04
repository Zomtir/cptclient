import 'package:cptclient/api/admin/location/location.dart' as api_admin;
import 'package:cptclient/json/location.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/pages/LocationEditPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    searchPanelKey.currentState?.setItems(locations);
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
            builder: (Location location, Function(Location)? onSelect) => InkWell(
              onTap: () => onSelect?.call(location),
              child: location.buildTile(),
            ),
            onSelect: _handleSelect,
          )
        ],
      ),
    );
  }
}
