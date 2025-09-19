import 'package:cptclient/api/admin/skill/skill.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class SkillEditPage extends StatefulWidget {
  final UserSession session;
  final Skill skill;
  final bool isDraft;

  SkillEditPage({super.key, required this.session, required this.skill, required this.isDraft});

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
    _ctrlRange = RangeValues(widget.skill.min.toDouble(), widget.skill.max.toDouble());
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
      messageText("${AppLocalizations.of(context)!.skillKey} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (widget.skill.title.isEmpty) {
      messageText("${AppLocalizations.of(context)!.skillTitle} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    bool success = widget.isDraft
        ? await api_admin.skill_create(widget.session, widget.skill)
        : await api_admin.skill_edit(widget.session, widget.skill);

    if (!success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.skill_delete(widget.session, widget.skill)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSkillEdit),
        actions: [
          if (!widget.isDraft)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
        ],
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) widget.skill.buildCard(context),
          AppInfoRow(
            info: AppLocalizations.of(context)!.skillKey,
            child: TextField(maxLines: 1, controller: _ctrlKey),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.skillTitle,
            child: TextField(maxLines: 1, controller: _ctrlTitle),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.skillRange,
            child: RangeSlider(
              values: _ctrlRange,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (RangeValues values) => setState(() => _ctrlRange = values),
              labels: RangeLabels("${_ctrlRange.start}", "${_ctrlRange.end}"),
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionSave,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
