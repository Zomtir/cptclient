import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
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
  final TextEditingController _ctrlUnitDuration = TextEditingController();
  final TextEditingController _ctrlCompensation = TextEditingController();
  final TextEditingController _ctrlDonation = TextEditingController();

  late final NumberFormat _nf;

  PresenceAccountingPageState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nf = NumberFormat.decimalPattern(Localizations.localeOf(context).toLanguageTag());
    _ctrlUnitDuration.text = _nf.format(0.75);
    _ctrlCompensation.text = _nf.format(6.15);
    _ctrlDonation.text = _nf.format(0.00);
  }

  _handleSubmission() {
    final num? unit_duration_num = _nf.tryParse(_ctrlUnitDuration.text);
    if (unit_duration_num == null) {
      messageText("${AppLocalizations.of(context)!.trainerUnitDuration} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    final num? compensation_num = _nf.tryParse(_ctrlCompensation.text);
    if (compensation_num == null) {
      messageText(
          "${AppLocalizations.of(context)!.trainerCompensationPerUnit} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    final num? donation_num = _nf.tryParse(_ctrlDonation.text);
    if (donation_num == null) {
      messageText(
          "${AppLocalizations.of(context)!.trainerCompensationDontation} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    double unit_duration = unit_duration_num.toDouble();
    double compensation_rate = compensation_num.toDouble();
    double compensation_hours =
        widget.events.fold(0, (total, event) => total + event.end.difference(event.begin).inMinutes) / 60;
    double compensation_units = ((compensation_hours / unit_duration) * 100).round() / 100;
    double compensation_sum = ((compensation_rate * compensation_units) * 100).round() / 100;
    double donation_sum = donation_num.toDouble();

    if (donation_sum > compensation_sum) {
      messageText("${AppLocalizations.of(context)!.trainerCompensationDontation} ($donation_sum Euro) "
          "> ${AppLocalizations.of(context)!.trainerCompensationTotal} ($compensation_sum Euro)");
      return;
    }

    trainer_accounting_pdf(
      context,
      widget.club,
      widget.user,
      widget.dateBegin,
      widget.dateEnd,
      widget.events,
      discipline: _ctrlDiscipline.text,
      unit_duration: unit_duration,
      compensation_rate: compensation_rate,
      compensation_hours: compensation_hours,
      compensation_units: compensation_units,
      compensation_sum: compensation_sum,
      disbursement_sum: compensation_sum - donation_sum,
      donation_sum: donation_sum,
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
            info: "${AppLocalizations.of(context)!.trainerUnitDuration} (${AppLocalizations.of(context)!.dateHour})",
            child: TextFormField(
              controller: _ctrlUnitDuration,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.trainerCompensationPerUnit} (Euro)",
            child: TextFormField(
              controller: _ctrlCompensation,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          AppInfoRow(
            info: "${AppLocalizations.of(context)!.trainerCompensationDontation} (Euro)",
            child: TextFormField(
              controller: _ctrlDonation,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          AppButton(
            text: AppLocalizations.of(context)!.actionDownload,
            onPressed: _handleSubmission,
          ),
        ],
      ),
    );
  }
}
