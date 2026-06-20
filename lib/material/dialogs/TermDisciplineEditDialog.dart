import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/term_discipline.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/widgets/AppDropdown.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
import 'package:cptclient/material/widgets/DropdownController.dart';
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class TermDisciplineEditDialog extends StatefulWidget {
  final Term term;
  final List<Discipline> disciplines;
  final TermDiscipline initialValue;
  final VoidCallback? onDelete;
  final Function(TermDiscipline)? onConfirm;

  TermDisciplineEditDialog({
    super.key,
    required this.term,
    required this.disciplines,
    required this.initialValue,
    this.onDelete,
    this.onConfirm,
  });

  @override
  TermDisciplineEditDialogState createState() => TermDisciplineEditDialogState();
}

class TermDisciplineEditDialogState extends State<TermDisciplineEditDialog> {
  late TermDiscipline currentValue;
  final DropdownController<Discipline> _ctrlDiscipline = DropdownController<Discipline>(items: []);
  final TextEditingController _ctrlBegin = TextEditingController();
  final TextEditingController _ctrlEnd = TextEditingController();

  TermDisciplineEditDialogState();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _ctrlDiscipline.items = widget.disciplines;
    _ctrlDiscipline.value = currentValue.discipline;
    _ctrlBegin.text = currentValue.begin?.toString() ?? widget.term.begin?.year.toString() ?? "";
    _ctrlEnd.text = currentValue.end?.toString() ?? widget.term.end?.year.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.discipline,
            child: AppDropdown<Discipline>(
              controller: _ctrlDiscipline,
              builder: (Discipline discipline) => Text(discipline.name),
              onChanged: (Discipline? discipline) => setState(() => _ctrlDiscipline.value = discipline),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.dateFrameBegin,
            child: TextField(
              maxLines: 1,
              controller: _ctrlBegin,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.dateFrameEnd,
            child: TextField(
              maxLines: 1,
              controller: _ctrlEnd,
            ),
          ),
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_ctrlDiscipline.value == null) {
                messageText(
                  "${AppLocalizations.of(context)!.discipline} ${AppLocalizations.of(context)!.statusIsInvalid}",
                );
                return;
              }

              currentValue.discipline = _ctrlDiscipline.value;
              currentValue.begin = int.tryParse(_ctrlBegin.text);
              currentValue.end = int.tryParse(_ctrlEnd.text);
              int? termBeginYear = widget.term.begin?.year;
              int? termEndYear = widget.term.end?.year;

              if (currentValue.begin != null && termBeginYear != null && currentValue.begin! < termBeginYear) {
                messageText(
                  "${AppLocalizations.of(context)!.dateFrameBegin} ${AppLocalizations.of(context)!.statusIsInvalid}",
                );
                return;
              }

              if (currentValue.end != null && termEndYear != null && currentValue.end! > termEndYear) {
                messageText(
                  "${AppLocalizations.of(context)!.dateFrameEnd} ${AppLocalizations.of(context)!.statusIsInvalid}",
                );
                return;
              }

              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
