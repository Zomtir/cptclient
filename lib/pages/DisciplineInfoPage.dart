import 'package:cptclient/api/admin/discipline/discipline.dart' as api_admin;
import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class DisciplineInfoPage extends StatefulWidget {
  final UserSession session;
  final Discipline discipline;

  DisciplineInfoPage({super.key, required this.session, required this.discipline});

  @override
  DisciplineInfoPageState createState() => DisciplineInfoPageState();
}

class DisciplineInfoPageState extends State<DisciplineInfoPage> {
  final TextEditingController _ctrlKey = TextEditingController();
  final TextEditingController _ctrlTitle = TextEditingController();

  DisciplineInfoPageState();

  @override
  void initState() {
    super.initState();
    _applyDiscipline();
  }

  void _applyDiscipline() {
    _ctrlKey.text = widget.discipline.key;
    _ctrlTitle.text = widget.discipline.title;
  }

  void _gatherDiscipline() {
    widget.discipline.key = _ctrlKey.text;
    widget.discipline.title = _ctrlTitle.text;
  }

  void _handleSubmit() async {
    _gatherDiscipline();

    if (widget.discipline.key.isEmpty) {
      messageText("${AppLocalizations.of(context)!.disciplineKey} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (widget.discipline.title.isEmpty) {
      messageText("${AppLocalizations.of(context)!.disciplineTitle} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    bool success = await api_admin.discipline_edit(widget.session, widget.discipline);

    if (!success) return;

    Navigator.pop(context);
  }

  void _handleDelete() async {
    if (!await api_admin.discipline_delete(widget.session, widget.discipline)) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageDisciplineInfo),
        actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
        ],
      ),
      body: AppBody(
        children: [
          widget.discipline.buildCard(context),
          AppInfoRow(
            info: AppLocalizations.of(context)!.disciplineKey,
            child: TextField(maxLines: 1, controller: _ctrlKey),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.disciplineTitle,
            child: TextField(maxLines: 1, controller: _ctrlTitle),
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
