import 'package:cptclient/api/admin/discipline/discipline.dart' as api_admin;
import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class DisciplineCreatePage extends StatefulWidget {
  final UserSession session;

  DisciplineCreatePage({super.key, required this.session});

  @override
  DisciplineCreatePageState createState() => DisciplineCreatePageState();
}

class DisciplineCreatePageState extends State<DisciplineCreatePage> {
  final TextEditingController _ctrlTitle = TextEditingController();

  DisciplineCreatePageState();

  @override
  void initState() {
    super.initState();

    Discipline discipline = Discipline.fromVoid();
    _ctrlTitle.text = discipline.name;
  }

  void _handleSubmit() async {
    if (_ctrlTitle.text.isEmpty) {
      messageText("${AppLocalizations.of(context)!.disciplineName} ${AppLocalizations.of(context)!.statusIsInvalid}");
      return;
    }

    Discipline discipline = Discipline.fromVoid();
    discipline.name = _ctrlTitle.text;

    var result = await api_admin.discipline_create(widget.session, discipline);
    if (result is! Success) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageDisciplineEdit),
      ),
      body: AppBody(
        builder: (context) => [
          AppInfoRow(
            info: AppLocalizations.of(context)!.disciplineName,
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
