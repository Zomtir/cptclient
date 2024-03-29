import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/EventInfoPage.dart';
import 'package:cptclient/static/server_event_regular.dart' as api_regular;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassOverviewAvailablePage extends StatefulWidget {
  final Session session;
  final Course course;

  ClassOverviewAvailablePage(
      {super.key, required this.session, required this.course});

  @override
  ClassOverviewAvailablePageState createState() =>
      ClassOverviewAvailablePageState();
}

class ClassOverviewAvailablePageState
    extends State<ClassOverviewAvailablePage> {
  List<Slot> _slots = [];

  ClassOverviewAvailablePageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() {
    _getCourseSlots();
  }

  Future<void> _getCourseSlots() async {
    List<Slot> slots = await api_regular.event_list(
      widget.session,
      courseTrue: true,
      courseID: widget.course.id,
    );
    slots.sort();

    setState(() {
      _slots = slots;
    });
  }

  Future<void> _selectCourseSlot(Slot slot, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventInfoPage(
          session: widget.session,
          slot: slot,
        ),
      ),
    );

    _getCourseSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventAvailable),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          AppListView<Slot>(
            items: _slots,
            itemBuilder: (Slot slot) {
              return InkWell(
                onTap: () => _selectCourseSlot(slot, false),
                child: AppSlotTile(
                  slot: slot,
                  trailing: [
                    IconButton(onPressed: null, icon: Icon(Icons.star_border)),
                    IconButton(onPressed: null, icon: Icon(Icons.star)),
                    IconButton(onPressed: null, icon: Icon(Icons.group_add)),
                    IconButton(onPressed: null, icon: Icon(Icons.group_off)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
