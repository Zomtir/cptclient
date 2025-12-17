import 'dart:math';

import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void trainer_accounting_pdf(
  BuildContext context,
  Club club,
  User user,
  DateTime date_from,
  DateTime date_until,
  List<Event> event_list, {
  required String discipline,
  required String role,
  required double unit_duration,
  required double compensation_rate,
  required double compensation_hours,
  required double compensation_units,
  required double compensation_sum,
  required double disbursement_sum,
  required double donation_sum,
}) async {
  var docTheme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load("assets/fonts/SourceSansPro/source-sans-pro.regular.ttf")),
    bold: pw.Font.ttf(await rootBundle.load("assets/fonts/SourceSansPro/source-sans-pro.bold.ttf")),
    italic: pw.Font.ttf(await rootBundle.load("assets/fonts/SourceSansPro/source-sans-pro.italic.ttf")),
    boldItalic: pw.Font.ttf(await rootBundle.load("assets/fonts/SourceSansPro/source-sans-pro.bold-italic.ttf")),
  );

  final doc = pw.Document(theme: docTheme);

  final clubBannerBytes = (await api_anon.club_banner(club.id)).unwrap();

  final int fiscal_year = date_from.year;
  final NumberFormat nf = NumberFormat.decimalPattern(Localizations.localeOf(context).toLanguageTag())..turnOffGrouping();

  pw.TextStyle styleBold = pw.TextStyle(fontWeight: pw.FontWeight.bold);

  pw.TextStyle styleHeading = pw.TextStyle(
    fontSize: 20,
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle styleTiny = pw.TextStyle(
    fontSize: 8,
  );

  pw.TextStyle styleTinyBold = pw.TextStyle(
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
  );

  pw.Border borderGrey = pw.Border.all(color: PdfColors.grey700, width: 1);

  pw.BoxDecoration boxInputDecoration = pw.BoxDecoration(color: PdfColors.grey50, border: borderGrey);

  pw.Widget buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          height: 15,
          child: pw.Text(
            (club.disciplines ?? '').split(',').join(' ∙ '),
            style: styleTiny,
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Divider(color: PdfColors.grey, thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(pw.MemoryImage(Uint8List.fromList(clubBannerBytes)), width: 200),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("$discipline / $role"),
                pw.Text("${date_from.fmtDate(context)} - ${date_until.fmtDate(context)}"),
                pw.Text("${user.firstname} ${user.lastname}"),
              ],
            ),
          ],
        ),
        pw.Divider(color: PdfColors.grey, thickness: 1),
      ],
    );
  }

  doc.addPage(
    pw.Page(
      build: (pw.Context pc) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          buildHeader(),
          pw.Text(
            AppLocalizations.of(context)!.trainerAccounting,
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(180),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.clubDivision),
                  pw.Text("$discipline"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.dateFrame),
                  pw.Text("${date_from.fmtDate(context)} - ${date_until.fmtDate(context)}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.eventRole),
                  pw.Text("$role}"),
                ],
              ),
              pw.TableRow(
                children: [pw.SizedBox(height: 10)],
              ),
              pw.TableRow(
                children: [
                  pw.Text(
                    "${AppLocalizations.of(context)!.userFirstname}, ${AppLocalizations.of(context)!.userLastname}",
                  ),
                  pw.Text("${user.firstname} ${user.lastname}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.userAddress),
                  pw.Text("${user.address}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.userPhone),
                  pw.Text("${user.phone}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.userEmail),
                  pw.Text("${user.email}"),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.bankaccIban),
                  pw.Text("${user.bank_account?.iban ?? ''}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.bankaccBic),
                  pw.Text("${user.bank_account?.bic ?? ''}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.bankaccInstitute),
                  pw.Text("${user.bank_account?.institute ?? ''}"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(AppLocalizations.of(context)!.trainerTimeStatement(club.name)),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(180),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerTimeTotal),
                  pw.Text("${nf.format(compensation_hours)} h"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerUnitDuration),
                  pw.Text("${nf.format(unit_duration)} h"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerUnitTotal),
                  pw.Text("${nf.format(compensation_units)}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerCompensationPerUnit),
                  pw.Text("${nf.format(compensation_rate)} Euro"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerCompensationTotal),
                  pw.Text("${nf.format(compensation_sum)} Euro"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            AppLocalizations.of(context)!.trainerWaiverStatement,
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Text(AppLocalizations.of(context)!.trainerWaiverDonationClause(club.name)),
          pw.SizedBox(height: 5),
          pw.Text(AppLocalizations.of(context)!.trainerWaiverTaxExemptionClause),
          pw.SizedBox(height: 10),
          pw.Table(
            tableWidth: pw.TableWidth.min,
            columnWidths: {
              0: const pw.FixedColumnWidth(180),
              1: const pw.FixedColumnWidth(100),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text(AppLocalizations.of(context)!.trainerCompensationTotal),
                  pw.Text("${nf.format(compensation_sum)} Euro"),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text("→ ${AppLocalizations.of(context)!.trainerCompensationDontation}"),
                  pw.Text("${nf.format(donation_sum)} Euro"),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text("→ ${AppLocalizations.of(context)!.trainerCompensationDisbursement}"),
                  pw.Text("${nf.format(disbursement_sum)} Euro"),
                ],
              ),
            ],
          ),
          pw.Spacer(),
          pw.Container(
            height: 50,
            padding: const pw.EdgeInsets.all(5),
            decoration: boxInputDecoration,
            child: pw.Text(
              "${AppLocalizations.of(context)!.signatureWithDateAndPlace} ${AppLocalizations.of(context)!.trainer}",
              style: styleTinyBold,
            ),
          ),
        ],
      ),
    ),
  );

  pw.TableRow buildUnitRow(Event event) {
    return pw.TableRow(
      children: [
        pw.Text(event.begin.fmtDate(context)),
        pw.Text(event.title),
        pw.Text(event.location?.name ?? ''),
        pw.Text("${event.begin.fmtTime(context)}-${event.end.fmtTime(context)}"),
        pw.Text("${event.end.difference(event.begin).inMinutes} min"),
      ],
    );
  }

  int eventsPerPage = 30;
  int pages = (event_list.length / eventsPerPage).ceil();

  for (int page = 0; page < pages; page++) {
    int startIndex = page * eventsPerPage;
    int endIndex = min(startIndex + eventsPerPage, event_list.length);
    List<Event> partial_events = event_list.sublist(startIndex, endIndex);
    int partial_minutes = partial_events.fold(0, (total, event) => total + event.end.difference(event.begin).inMinutes);

    doc.addPage(
      pw.Page(
        build: (pw.Context pwcontext) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            buildHeader(),
            pw.Text(
              "${AppLocalizations.of(context)!.trainerTimeTable} - ${AppLocalizations.of(context)!.labelPage} ${page + 1}",
              textAlign: pw.TextAlign.center,
              style: styleHeading,
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text(AppLocalizations.of(context)!.dateDate, style: styleBold),
                    pw.Text(AppLocalizations.of(context)!.trainerEventActivity, style: styleBold),
                    pw.Text(AppLocalizations.of(context)!.trainerEventLocation, style: styleBold),
                    pw.Text(AppLocalizations.of(context)!.dateTime, style: styleBold),
                    pw.Text(AppLocalizations.of(context)!.dateDuration, style: styleBold),
                  ],
                ),
                ...partial_events.map((event) => buildUnitRow(event)),
              ],
            ),
            pw.Spacer(),
            pw.Text(
              AppLocalizations.of(context)!.labelSubtotal,
              textAlign: pw.TextAlign.right,
              style: styleBold,
            ),
            pw.Text(
              "$partial_minutes min",
              textAlign: pw.TextAlign.right,
            ),
            pw.Text(
              "${nf.format(partial_minutes / 60)} h",
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              height: 40,
              padding: const pw.EdgeInsets.all(5),
              decoration: boxInputDecoration,
              child: pw.Text(AppLocalizations.of(context)!.labelComment, style: styleTinyBold),
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    height: 40,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: boxInputDecoration,
                    child: pw.Text(
                      "${AppLocalizations.of(context)!.signatureWithDate} ${AppLocalizations.of(context)!.trainer}",
                      style: styleTinyBold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    height: 40,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: boxInputDecoration,
                    child: pw.Text(
                      "${AppLocalizations.of(context)!.signatureWithDate} ${AppLocalizations.of(context)!.clubDivisionHead}",
                      style: styleTinyBold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  doc.addPage(
    pw.Page(
      build: (pw.Context pwcontext) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          buildHeader(),
          pw.Text(
            AppLocalizations.of(context)!.trainerTaxExemptionStatement,
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            AppLocalizations.of(context)!.trainerTaxExemptionClause(club.name, club.chairman ?? '\t\t\t'),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            AppLocalizations.of(context)!.trainerTaxExemptionExplanation,
            textAlign: pw.TextAlign.justify,
            style: styleTiny,
          ),
          pw.SizedBox(height: 10),
          pw.Text(AppLocalizations.of(context)!.trainerTaxPartTime),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text(AppLocalizations.of(context)!.labelYes),
              pw.SizedBox(width: 50),
              pw.Text("☐ "),
              pw.Text(AppLocalizations.of(context)!.labelNo),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(AppLocalizations.of(context)!.trainerTaxAssignmentDeclaration(fiscal_year.toString())),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Text(
                      AppLocalizations.of(context)!.trainerTaxAssignmentExclusive,
                      textAlign: pw.TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      AppLocalizations.of(context)!.trainerTaxAssignmentShared,
                      textAlign: pw.TextAlign.justify,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Container(
                      decoration: boxInputDecoration,
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        columnWidths: {
                          0: const pw.FlexColumnWidth(100),
                          1: const pw.FlexColumnWidth(100),
                          2: const pw.FixedColumnWidth(50),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(AppLocalizations.of(context)!.clubName, style: styleTinyBold),
                              pw.Text(AppLocalizations.of(context)!.clubAddress, style: styleTinyBold),
                              pw.Text(AppLocalizations.of(context)!.labelAmount, style: styleTinyBold),
                            ],
                          ),
                          pw.TableRow(
                            children: [pw.SizedBox(height: 15)],
                          ),
                          pw.TableRow(
                            children: [pw.SizedBox(height: 15)],
                          ),
                          pw.TableRow(
                            children: [pw.SizedBox(height: 15)],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            AppLocalizations.of(context)!.trainerLicenseDeclaration,
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(120),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text("${AppLocalizations.of(context)!.userLicenseMain}:"),
                  pw.Text(
                    user.license_main == null ? "-" : "${user.license_main!.name} (${user.license_main!.number})",
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("${AppLocalizations.of(context)!.userLicenseExtra}:"),
                  pw.Text(
                    user.license_extra == null ? "-" : "${user.license_extra!.name} (${user.license_extra!.number})",
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(AppLocalizations.of(context)!.trainerLicenseUsageStatement(club.name, fiscal_year.toString())),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text(AppLocalizations.of(context)!.trainerLicenseUsageFull),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text(AppLocalizations.of(context)!.trainerLicenseUsageSplit),
            ],
          ),
          pw.Spacer(),
          pw.Container(
            height: 50,
            padding: const pw.EdgeInsets.all(5),
            decoration: boxInputDecoration,
            child: pw.Text(
              "${AppLocalizations.of(context)!.signatureWithDateAndPlace} ${AppLocalizations.of(context)!.trainer}",
              style: styleTinyBold,
            ),
          ),
        ],
      ),
    ),
  );
  // TODO fix name
  exportPDF('trainer_accounting', await doc.save());
}
