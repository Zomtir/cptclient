import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:cptclient/pages/ClassDetailManagementPage.dart';
import 'package:cptclient/pages/SlotCreateBatchPage.dart';
import 'package:cptclient/pages/SlotEditPage.dart';
import 'package:cptclient/static/server_event_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassOverviewManagementPage extends StatefulWidget {
  final Session session;
  final Course course;
  final bool isDraft;

  ClassOverviewManagementPage({super.key, required this.session, required this.course, required this.isDraft});

  @override
  ClassOverviewManagementPageState createState() => ClassOverviewManagementPageState();
}

class ClassOverviewManagementPageState extends State<ClassOverviewManagementPage> {
  List<Slot> _slots = [];

  ClassOverviewManagementPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    List<Slot> slots = await api_admin.event_list(widget.session, courseTrue: true, courseID: widget.course.id);
    slots.sort();

    setState(() {
      _slots = slots;
    });
  }

  Future<void> _createClass() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotEditPage(
          session: widget.session,
          slot: Slot.fromCourse(widget.course),
          isDraft: true,
          onSubmit: (Session session, Slot slot) async {
            if (!await api_admin.event_create(session, widget.course.id, slot)) return false;
            _update();
            return true;
          },
        ),
      ),
    );
  }

  Future<void> _createClassBatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SlotCreateBatchPage(
          session: widget.session,
          slot: Slot.fromCourse(widget.course),
          isDraft: true,
          onSubmit: (Session session, Slot slot) async {
            if (!await api_admin.event_create(session, widget.course.id, slot)) return false;
            _update();
            return true;
          },
        ),
      ),
    );
  }

  Future<void> _selectCourseSlot(Slot slot, bool isDraft) async {
    print("hi0");
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailManagementPage(
          session: widget.session,
          slotID: slot.id,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Class Management"),
      ),
      body: AppBody(
        children: <Widget>[
          AppCourseTile(
            course: widget.course,
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: _createClass,
          ),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreateBatch,
            onPressed: _createClassBatch,
          ),
          AppListView<Slot>(
            items: _slots,
            itemBuilder: (Slot slot) {
              return InkWell(
                onTap: () => _selectCourseSlot(slot, false),
                child: AppSlotTile(
                  slot: slot,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
