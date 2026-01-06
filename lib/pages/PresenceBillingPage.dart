import 'dart:typed_data';

import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/fields/DateTimeController.dart';
import 'package:cptclient/material/fields/DateTimeField.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/layouts/InfoSection.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/material/widgets/SectionToggle.dart';
import 'package:cptclient/material/widgets/Signature.dart';
import 'package:cptclient/utils/billing.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';

class PresenceBillingPage extends StatefulWidget {
  final UserSession session;
  final Club club;
  final User user;
  final String role;
  final DateTime dateBegin;
  final DateTime dateEnd;
  final List<Event> events;

  PresenceBillingPage({
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
  PresenceBillingPageState createState() => PresenceBillingPageState();
}

class PresenceBillingPageState extends State<PresenceBillingPage> {
  final TextEditingController _ctrlDiscipline = TextEditingController();
  final TextEditingController _ctrlRole = TextEditingController();
  final TextEditingController _ctrlUnitDuration = TextEditingController();
  final TextEditingController _ctrlCompensation = TextEditingController();
  final TextEditingController _ctrlDonation = TextEditingController();

  final TextEditingController _ctrlComment = TextEditingController();

  String _ctrlJobPriority = "SUPPLEMENTARY";
  String _ctrlJobAllowance = "EXCLUSIVE";
  final TextEditingController _ctrlJobInstitutions = TextEditingController();
  String _ctrlLicenseUsage = "FULL";

  final TextEditingController _ctrlLocation = TextEditingController();
  final DateTimeController _ctrlDate = DateTimeController(dateTime: DateTime.now());
  final HandSignatureControl _ctrlStroke = HandSignatureControl();

  late final NumberFormat nf = NumberFormat.decimalPattern(Localizations.localeOf(context).toLanguageTag())
    ..turnOffGrouping();

  double? unit_duration;
  double? compensation_rate;
  double compensation_hours = 0;
  double? compensation_units;
  double? compensation_sum;
  double? donation_sum;
  double? disbursement_sum;

  PresenceBillingPageState();

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

  void _handleSubmission() async {
    _recalculate();

    final ByteData? signatureData = await _ctrlStroke.toImage(fit: true, width: 600, height: 200);
    final Uint8List? signatureBytes = signatureData?.buffer.asUint8List();

    billing_instructor_pdf(
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
      comment: _ctrlComment.text,
      job_priority: _ctrlJobPriority,
      job_allowance: _ctrlJobAllowance,
      job_institutions: _ctrlJobInstitutions.text,
      job_licence_usage: _ctrlLicenseUsage,
      signature_location: _ctrlLocation.text,
      signature_date: _ctrlDate.getDate(),
      signature_stroke: signatureBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trainerBilling),
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
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerUnitDuration),
                    Text("${nf.format(unit_duration)} h"),
                  ],
                ),
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerCompensationPerUnit),
                    Text("${nf.format(compensation_rate)} €"),
                  ],
                ),
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerTimeTotal),
                    Text("${nf.format(compensation_hours)} h"),
                  ],
                ),
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerUnitTotal),
                    Text(nf.format(compensation_units)),
                  ],
                ),
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerCompensationTotal),
                    Text("${nf.format(compensation_sum)} €"),
                  ],
                ),
                TableRow(
                  children: [
                    Text(AppLocalizations.of(context)!.trainerCompensationDontation),
                    Text("${nf.format(donation_sum)} €"),
                  ],
                ),
                TableRow(
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
          SectionToggle(
            title: AppLocalizations.of(context)!.labelMoreDetails,
            children: [
              AppInfoRow(
                info: "Additional comments for the time table?",
                child: TextFormField(
                  controller: _ctrlComment,
                  maxLines: 3,
                ),
              ),
              AppInfoRow(
                info: "Employment type at the club?",
                child: RadioGroup<String>(
                  groupValue: _ctrlJobPriority,
                  onChanged: (String? value) {
                    setState(() {
                      _ctrlJobPriority = value!;
                    });
                  },
                  child: const Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Supplementary Employment"),
                        leading: Radio<String>(value: "SUPPLEMENTARY"),
                      ),
                      ListTile(
                        title: Text("Incidental Employment"),
                        leading: Radio<String>(value: "INCIDENTAL"),
                      ),
                    ],
                  ),
                ),
              ),
              AppInfoRow(
                info: "Additional activities with allowances eligible for tax relief?",
                child: RadioGroup<String>(
                  groupValue: _ctrlJobAllowance,
                  onChanged: (String? value) => setState(() => _ctrlJobAllowance = value!),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text('No other activities outside of this club'),
                        leading: Radio<String>(value: "EXCLUSIVE"),
                      ),
                      ListTile(
                        title: TextFormField(
                          controller: _ctrlJobInstitutions,
                          decoration: InputDecoration(hint: Text("Name/Address/Allowance (€) of other institution(s)")),
                          maxLines: 3,
                        ),
                        leading: const Radio<String>(value: "NON-EXCLUSIVE"),
                      ),
                    ],
                  ),
                ),
              ),
              AppInfoRow(
                info: "Use licence for the club?",
                child: RadioGroup<String>(
                  groupValue: _ctrlLicenseUsage,
                  onChanged: (String? value) => setState(() => _ctrlLicenseUsage = value!),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text('Full'),
                        leading: Radio<String>(value: "FULL"),
                      ),
                      const ListTile(
                        title: Text('Split'),
                        leading: Radio<String>(value: "SPLIT"),
                      ),
                      const ListTile(
                        title: Text('None'),
                        leading: Radio<String>(value: "NONE"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          InfoSection(title: AppLocalizations.of(context)!.labelSignature),
          AppInfoRow(
            info: AppLocalizations.of(context)!.location,
            child: TextFormField(controller: _ctrlLocation),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.dateDate,
            child: DateTimeField(controller: _ctrlDate, showTime: false, nullable: false),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.labelSignature,
            child: Signature(control: _ctrlStroke, width: 950, height: 150),
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
