import 'package:cptclient/api/admin/skill/skill.dart' as api_admin;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class SkillCreatePage extends StatefulWidget {
  final UserSession session;

  SkillCreatePage({super.key, required this.session});

  @override
  SkillCreatePageState createState() => SkillCreatePageState();
}

class SkillCreatePageState extends State<SkillCreatePage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlTitle = TextEditingController();
  RangeValues _ctrlRange = RangeValues(0, 10);

  SkillCreatePageState();

  @override
  void initState() {
    super.initState();

    Skill skill = Skill.fromVoid();
    _ctrlKey.text = skill.key;
    _ctrlTitle.text = skill.title;
    _ctrlRange = RangeValues(skill.min as double, skill.max as double);
  }

  void _handleSubmit() async {
    if (_ctrlKey.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.skillKey} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    if (_ctrlTitle.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.skillTitle} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Skill skill = Skill.fromVoid();
    skill.key = _ctrlKey.text;
    skill.title = _ctrlTitle.text;
    skill.min = _ctrlRange.start as int;
    skill.max = _ctrlRange.end as int;

    var result = await api_admin.skill_create(widget.session, skill);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageSkillEdit),
      ),
      body: AppBody(
        children: [
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
