import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppCourseTile.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseClubEditPage extends StatefulWidget {
  final UserSession session;
  final Course course;
  final Future<List<Club>> Function() callList;
  final Future<int?> Function() callInfo;
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

  _update() async {
    List<Club> courses = await widget.callList();
    int? courseID = await widget.callInfo();

    setState(() {
      _ctrlClub.items = courses;
      _ctrlClub.value = (courseID == null) ? null : courses.firstWhere((club) => club.id == courseID);
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
          AppCourseTile(
            course: widget.course,
          ),
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
