import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/pages/RequirementEditPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class RequirementOverviewPage extends StatefulWidget {
  final UserSession session;
  final Course course;

  RequirementOverviewPage({super.key, required this.session, required this.course});

  @override
  RequirementOverviewPageState createState() => RequirementOverviewPageState();
}

class RequirementOverviewPageState extends State<RequirementOverviewPage> {
  List<Requirement> _requirements = [];

  RequirementOverviewPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    var result_requirements = await api_admin.course_requirement_list(widget.session, widget.course);
    if (result_requirements is! Success) return;
    setState(() => _requirements = result_requirements.unwrap());
  }

  Future<void> _handleSelect(Requirement requirement, bool isDraft) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequirementEditPage(
          session: widget.session,
          requirement: requirement,
          isDraft: isDraft,
        ),
      ),
    );

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseRequirements),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: () => _handleSelect(Requirement.fromCourse(widget.course), true),
          ),
        ],
      ),
      body: AppBody(
        children: [
          widget.course.buildCard(context),
          AppListView<Requirement>(
            items: _requirements,
            itemBuilder: (Requirement requirement) => requirement.buildTile(
              context,
              onTap: () => _handleSelect(requirement, false),
            ),
          ),
        ],
      ),
    );
  }
}
