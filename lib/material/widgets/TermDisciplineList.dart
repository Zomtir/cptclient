import 'package:cptclient/json/discipline.dart';
import 'package:cptclient/json/term.dart';
import 'package:cptclient/json/term_discipline.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/TermDisciplineEditDialog.dart';
import 'package:cptclient/material/widgets/IconLabel.dart';
import 'package:flutter/material.dart';

class TermDisciplineList extends StatelessWidget {
  final Term term;
  final List<Discipline> disciplines;
  final List<TermDiscipline> termDisciplines;
  final VoidCallback onChanged;
  final Function(TermDiscipline)? onCreate;
  final Function(TermDiscipline)? onEdit;
  final Function(TermDiscipline)? onDelete;

  const TermDisciplineList({
    super.key,
    required this.term,
    required this.disciplines,
    required this.termDisciplines,
    required this.onChanged,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
  });

  void addItem(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => TermDisciplineEditDialog(
        term: term,
        disciplines: disciplines,
        initialValue: TermDiscipline.fromVoid(),
        onConfirm: (TermDiscipline td) async {
          await onCreate?.call(td);
          onChanged();
        },
      ),
    );
  }

  void editItem(BuildContext context, TermDiscipline termDiscipline) async {
    await showDialog(
      context: context,
      builder: (context) => TermDisciplineEditDialog(
        term: term,
        disciplines: disciplines,
        initialValue: termDiscipline,
        onConfirm: (TermDiscipline td) async {
          await onEdit?.call(td);
          onChanged();
        },
      ),
    );
  }

  void removeItem(int index) async {
    await onDelete?.call(termDisciplines[index]);
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          columns: [
            DataColumn(label: Text(AppLocalizations.of(context)!.discipline), columnWidth: FlexColumnWidth()),
            DataColumn(
              label: Text(AppLocalizations.of(context)!.labelFrom),
              columnWidth: FixedColumnWidth(70),
            ),
            DataColumn(
              label: Text(AppLocalizations.of(context)!.labelTo),
              columnWidth: FixedColumnWidth(70),
            ),
            DataColumn(
              label: IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => addItem(context)),
              columnWidth: FixedColumnWidth(70),
            ),
          ],
          rows: List<DataRow>.generate(termDisciplines.length, (index) {
            return DataRow(
              cells: <DataCell>[
                DataCell(IconLabel(Icons.edit, "${termDisciplines[index].discipline!.name}"), onTap: () => editItem(context, termDisciplines[index])),
                DataCell(Text("${termDisciplines[index].begin ?? "-"}")),
                DataCell(Text("${termDisciplines[index].end ?? "-"}")),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => removeItem(index),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
