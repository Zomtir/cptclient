import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/tiles/AppRequirementTile.dart';
import 'package:cptclient/pages/RequirementEditPage.dart';
import 'package:cptclient/static/server_course_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequirementOverviewPage extends StatefulWidget {
  final Session session;
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
    List<Requirement> requirements = await api_admin.course_requirement_list(widget.session, widget.course);

    setState(() => _requirements = requirements);
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
      ),
      body: AppBody(
        children: [
          AppCourseTile(course: widget.course),
          AppButton(
            leading: Icon(Icons.add),
            text: AppLocalizations.of(context)!.actionCreate,
            onPressed: () => _handleSelect(Requirement.fromCourse(widget.course), true),
          ),
          AppListView<Requirement>(
            items: _requirements,
            itemBuilder: (Requirement requirement) {
              return InkWell(
                onTap: () => _handleSelect(requirement, false),
                child: AppRequirementTile(
                  requirement: requirement,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
