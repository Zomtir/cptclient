import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class CourseClubEditPage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final Future<Result<List<Club>>> Function() callList;
  final Future<Result<int>> Function() callInfo;
  final Future<void> Function(Club?) callEdit;

  CourseClubEditPage(
      {super.key,
      required this.session,
      required this.course,
      required this.callList,
      required this.callInfo,
      required this.callEdit});

  @override
  CourseClubEditPageState createState() => CourseClubEditPageState();
}

class CourseClubEditPageState extends State<CourseClubEditPage> {
  final DropdownController<Club> _ctrlClub = DropdownController<Club>(items: []);

  CourseClubEditPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  Future<void> _update() async {
    Result<List<Club>> result_courses = await widget.callList();
    Result<int> result_course_id = await widget.callInfo();

    if (result_courses is! Success || result_course_id is! Success) return;

    setState(() {
      _ctrlClub.items = result_courses.unwrap();
      _ctrlClub.value = result_courses.unwrap().firstWhere((club) => club.id == result_course_id.unwrap());
    });
  }

  Future<void> _handleCourse(Club? club) async {
    await widget.callEdit(club);
    setState(() => _ctrlClub.value = club);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseClub),
      ),
      body: AppBody(
        children: [
          widget.course.buildCard(context),
          AppInfoRow(
            info: AppLocalizations.of(context)!.club,
            child: AppDropdown<Club>(
              controller: _ctrlClub,
              builder: (Club club) => Text(club.name),
              onChanged: (club) => _handleCourse(club),
            ),
          ),
        ],
      ),
    );
  }
}
