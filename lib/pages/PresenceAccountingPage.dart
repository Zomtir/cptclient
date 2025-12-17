import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/trainer_accounting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresenceAccountingPage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final User user;
  final String role;
  final DateTime dateBegin;
  final DateTime dateEnd;
  final List<Event> events;

  PresenceAccountingPage({
    super.key,
    required this.session,
    required this.club,
    required this.user,
    required this.role,
    required this.dateBegin,
    required this.dateEnd,
    required this.events,
  });

  @override
  PresenceAccountingPageState createState() => PresenceAccountingPageState();
}

class PresenceAccountingPageState extends State<PresenceAccountingPage> {
  final TextEditingController _ctrlDiscipline = TextEditingController();
  final TextEditingController _ctrlRole = TextEditingController();
  final TextEditingController _ctrlUnitDuration = TextEditingController();
  final TextEditingController _ctrlCompensation = TextEditingController();
  final TextEditingController _ctrlDonation = TextEditingController();

  late final NumberFormat nf = NumberFormat.decimalPattern(Localizations.localeOf(context).toLanguageTag())..turnOffGrouping();

  double? unit_duration;
  double? compensation_rate;
  double compensation_hours = 0;
  double? compensation_units;
  double? compensation_sum;
  double? donation_sum;
  double? disbursement_sum;

  PresenceAccountingPageState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ctrlUnitDuration.text = nf.format(0.75);
    _ctrlCompensation.text = nf.format(6.15);
    _ctrlDonation.text = nf.format(0.00);
    _recalculate();
  }

  void _recalculate() {
    setState(() {
      compensation_hours =
          widget.events.fold(0, (total, event) => total + event.end.difference(event.begin).inMinutes) / 60;

      unit_duration = nf.tryParse(_ctrlUnitDuration.text)?.toDouble();
      compensation_rate = nf.tryParse(_ctrlCompensation.text)?.toDouble();
      donation_sum = nf.tryParse(_ctrlDonation.text)?.toDouble();

      compensation_units = null;
      compensation_sum = null;
      disbursement_sum = null;
    });

    if (unit_duration == null) return;

    setState(() {
      compensation_units = ((compensation_hours / unit_duration!) * 100).round() / 100;
    });

    if (compensation_rate == null) return;

    setState(() {
      compensation_sum = ((compensation_rate! * compensation_units!) * 100).round() / 100;
    });

    if (donation_sum == null) return;

    setState(() {
      disbursement_sum = compensation_sum! - donation_sum!;
    });
  }

  void _handleSubmission() {
    _recalculate();

    trainer_accounting_pdf(
      context,
      widget.club,
      widget.user,
      widget.dateBegin,
      widget.dateEnd,
      widget.events,
      discipline: _ctrlDiscipline.text,
      role: _ctrlRole.text,
      unit_duration: unit_duration!,
      compensation_rate: compensation_rate!,
      compensation_hours: compensation_hours,
      compensation_units: compensation_units!,
      compensation_sum: compensation_sum!,
      disbursement_sum: disbursement_sum!,
      donation_sum: donation_sum!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trainerAccounting),
      ),
      body: AppBody(
        maxWidth: 1000,
        children: <Widget>[
          AppInfoRow(
            info: AppLocalizations.of(context)!.userDiscipline,
            child: TextField(
              maxLines: 1,
              controller: _ctrlDiscipline,
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.eventRole,
            child: TextField(
              maxLines: 1,
              controller: _ctrlRole,
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.trainerUnitDuration} (${AppLocalizations.of(context)!.dateHour})",
            child: TextFormField(
              controller: _ctrlUnitDuration,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recalculate(),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.trainerCompensationPerUnit} (Euro)",
            child: TextFormField(
              controller: _ctrlCompensation,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recalculate(),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.trainerCompensationDontation} (Euro)",
            child: TextFormField(
              controller: _ctrlDonation,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recalculate(),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelSummary,
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(width: 0.2),
              ),
              columnWidths: const {
                0: FixedColumnWidth(220),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerUnitDuration),
                  Text("${nf.format(unit_duration)} h"),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerCompensationPerUnit),
                  Text("${nf.format(compensation_rate)} €"),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerTimeTotal),
                  Text("${nf.format(compensation_hours)} h"),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerUnitTotal),
                  Text(nf.format(compensation_units)),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerCompensationTotal),
                  Text("${nf.format(compensation_sum)} €"),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerCompensationDontation),
                  Text("${nf.format(donation_sum)} €"),
                ]),
                TableRow(children: [
                  Text(AppLocalizations.of(context)!.trainerCompensationDisbursement),
                  Text(
                    switch (disbursement_sum) {
                      null => AppLocalizations.of(context)!.undefined,
                      < 0 =>
                      "${AppLocalizations.of(context)!.trainerCompensationDontation} "
                          "> ${AppLocalizations.of(context)!.trainerCompensationTotal}",
                      _ => "${nf.format(disbursement_sum)} €",
                    },
                  ),
                ]),
              ],
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionDownload,
            onPressed: (disbursement_sum != null && disbursement_sum! >= 0) ? _handleSubmission : null,
          ),
        ],
      ),
    );
  }
}
