import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppSkillTile.dart';
import 'package:cptclient/static/server_skill_admin.dart' as api_admin;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkillEditPage extends StatefulWidget {
  final Session session;
  final Skill skill;
  final void Function() onUpdate;
  final bool isDraft;

  SkillEditPage(
      {super.key,
      required this.session,
      required this.skill,
      required this.onUpdate,
      required this.isDraft});

  @override
  SkillEditPageState createState() => SkillEditPageState();
}

class SkillEditPageState extends State<SkillEditPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlTitle = TextEditingController();
  RangeValues _ctrlRange = RangeValues(0, 10);

  SkillEditPageState();

  @override
  void initState() {
    super.initState();
    _applySkill();
  }

  void _applySkill() {
    _ctrlKey.text = widget.skill.key;
    _ctrlTitle.text = widget.skill.title;
    _ctrlRange =
        RangeValues(widget.skill.min as double, widget.skill.max as double);
  }

  void _gatherSkill() {
    widget.skill.key = _ctrlKey.text;
    widget.skill.title = _ctrlTitle.text;
    widget.skill.min = _ctrlRange.start as int;
    widget.skill.max = _ctrlRange.end as int;
  }

  void _handleSubmit() async {
    _gatherSkill();

    if (widget.skill.key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.skillKey} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    if (widget.skill.title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${AppLocalizations.of(context)!.skillTitle} ${AppLocalizations.of(context)!.isInvalid}")));
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.skill_create(widget.session, widget.skill)
        : await api_admin.skill_edit(widget.session, widget.skill);

    if (!success) return;

    widget.onUpdate();
    Navigator.pop(context);
  }

  void _deleteUser() async {
    if (!await api_admin.skill_delete(widget.session, widget.skill)) return;

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSkillManagement),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft)
            Row(
              children: [
                Expanded(
                  child: AppSkillTile(skill: widget.skill),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteUser,
                ),
              ],
            ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.skillKey),
            child: TextField(
              maxLines: 1,
              controller: _ctrlKey,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.skillTitle),
            child: TextField(
              maxLines: 1,
              controller: _ctrlTitle,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.skillRange),
            child: RangeSlider(
              values: _ctrlRange,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (RangeValues values) => {},
              labels: RangeLabels("${_ctrlRange.start}", "${_ctrlRange.end}"),
            ),
          ),
          AppButton(
            text: "Save",
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
