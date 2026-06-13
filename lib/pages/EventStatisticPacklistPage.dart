import 'package:cptclient/api/admin/event/event.dart' as api_admin;
import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/utils/pdf_handover.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EventStatisticPacklistPage extends StatefulWidget {
  final UserSession session;
  final Event event;

  EventStatisticPacklistPage({
    super.key,
    required this.session,
    required this.event,
  });

  @override
  EventStatisticPacklistPageState createState() => EventStatisticPacklistPageState();
}

class EventStatisticPacklistPageState extends State<EventStatisticPacklistPage> {
  EventStatisticPacklistPageState();

  late Skill _ctrlSkill;
  List<(User, Item, int, int, int)> _stats = [];

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  void _prepare() async {
    Result<List<Skill>> result_skills = await api_anon.skill_list();
    if (result_skills is! Success) return;
    Skill? skill;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(
        items: result_skills.unwrap(),
        onPick: (item) => skill = item,
      ),
    );
    if (skill == null) {
      Navigator.pop(context);
    }
    setState(() => _ctrlSkill = skill!);
    _update();
  }

  void _update() async {
    var result = await api_admin.event_statistic_packlist(
      widget.session,
      widget.event,
      _ctrlSkill.id,
    );
    if (result is! Success) return;

    List<(User, Item, int, int, int)> stats = result.unwrap();
    stats.sort((a, b) => a.$1.compareTo(b.$1));
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventStatisticPacklist),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => handover_protocol_pdf(context, widget.event, _stats),
          ),
        ],
      ),
      body: AppBody(
        maxWidth: 1000,
        builder: (context) => [
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.user)),
              DataColumn(label: Text(AppLocalizations.of(context)!.item)),
              DataColumn(label: Text(AppLocalizations.of(context)!.labelRequired)),
              DataColumn(label: Text(AppLocalizations.of(context)!.labelOwned)),
              DataColumn(label: Text(AppLocalizations.of(context)!.labelNeeded)),
            ],
            rows: [
              ...List<DataRow>.generate(_stats.length, (index) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(_stats[index].$1.buildEntry(context)),
                    DataCell(_stats[index].$2.buildEntry(context)),
                    DataCell(Text("${_stats[index].$3}")),
                    DataCell(Text("${_stats[index].$4}")),
                    DataCell(Text("${_stats[index].$5}")),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
