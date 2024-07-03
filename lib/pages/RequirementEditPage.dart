import 'package:cptclient/api/admin/course/imports.dart' as api_admin;
import 'package:cptclient/json/course.dart';
import 'package:cptclient/json/requirement.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/fields/FieldController.dart';
import 'package:cptclient/material/fields/SkillRankField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppRequirementTile.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/static/server_skill_anon.dart' as api_anon;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequirementEditPage extends StatefulWidget {
  final UserSession session;
  final Requirement requirement;
  final bool isDraft;

  RequirementEditPage({super.key, required this.session, required this.requirement, required this.isDraft});

  @override
  RequirementEditPageState createState() => RequirementEditPageState();
}

class RequirementEditPageState extends State<RequirementEditPage> {
  final FieldController<Course> _ctrlCourse = FieldController();
  final FieldController<Skill> _ctrlSkill = FieldController();
  int _ctrlRank = 0;

  RequirementEditPageState();

  @override
  void initState() {
    super.initState();
    _ctrlSkill.callItems = api_anon.skill_list;
    _applyInfo();
  }

  void _applyInfo() {
    _ctrlCourse.value = widget.requirement.course;
    _ctrlSkill.value = widget.requirement.skill;
    _ctrlRank = widget.requirement.rank;
  }

  void _gatherInfo() {
    widget.requirement.course = _ctrlCourse.value;
    widget.requirement.skill = _ctrlSkill.value;
    widget.requirement.rank = _ctrlRank;
  }

  void _handleSubmit() async {
    _gatherInfo();

    if (widget.requirement.skill == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${AppLocalizations.of(context)!.skill} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = await api_admin.course_requirement_add(widget.session, widget.requirement);

    if (!success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.course_requirement_remove(widget.session, widget.requirement)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageCourseRequirements),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) AppRequirementTile(
            requirement: widget.requirement,
            trailing: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _handleDelete,
              ),
            ],
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.competenceSkill,
            child: SkillRankField(
              controller: _ctrlSkill,
              rank: _ctrlRank,
              onChanged: (Skill? skill, int rank) => setState(() {
                _ctrlSkill.value = skill;
                _ctrlRank = rank;
              }),
            ),
          ),
          if (widget.isDraft) AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
