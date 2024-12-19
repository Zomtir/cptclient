import 'dart:math';

import 'package:cptclient/api/anon/club.dart' as api_anon;
import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void trainer_accounting_pdf(BuildContext context, Club club, User user, String discipline, DateTime date_from,
    DateTime date_until, List<Event> event_list) async {
  var docTheme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load("fonts/SourceSansPro/source-sans-pro.regular.ttf")),
    bold: pw.Font.ttf(await rootBundle.load("fonts/SourceSansPro/source-sans-pro.bold.ttf")),
    italic: pw.Font.ttf(await rootBundle.load("fonts/SourceSansPro/source-sans-pro.italic.ttf")),
    boldItalic: pw.Font.ttf(await rootBundle.load("fonts/SourceSansPro/source-sans-pro.bold-italic.ttf")),
  );

  final doc = pw.Document(theme: docTheme);

  final clubBannerBytes = (await api_anon.club_banner(club.id))!;

  final int fiskal_year = date_from.year;
  final locale = "de_DE";

  double compensation_hours =
      event_list.fold(0, (total, event) => total + event.end.difference(event.begin).inMinutes) / 60;
  double compensation_unit_duration = 0.75;
  double compensation_units = (compensation_hours / compensation_unit_duration).roundToDouble();
  double compensation_rate = 6.15;
  double compensation_sum = compensation_rate * compensation_units;

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
        pw.Text(
          club.disciplines!,
          style: styleTiny,
          textAlign: pw.TextAlign.center,
        ),
        pw.Divider(color: PdfColors.grey, thickness: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(pw.MemoryImage(Uint8List.fromList(clubBannerBytes)), width: 200),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("$discipline"),
                pw.Text("${date_from.fmtDate(context)} - ${date_until.fmtDate(context)}"),
                pw.Text("${user.firstname} ${user.lastname}"),
              ],
            )
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
            "Übungsleiterabrechnung",
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
                  pw.Text("Abteilung"),
                  pw.Text("$discipline"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Zeitraum"),
                  pw.Text("${date_from.fmtDate(context)} - ${date_until.fmtDate(context)}"),
                ],
              ),
              pw.TableRow(
                children: [pw.SizedBox(height: 10)],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Vorname, Name"),
                  pw.Text("${user.firstname} ${user.lastname}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Anschrift"),
                  pw.Text("${user.address}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Telefon"),
                  pw.Text("${user.phone}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("E-Mail"),
                  pw.Text("${user.email}"),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text("IBAN"),
                  pw.Text("${user.bank_account!.iban}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("BIC"),
                  pw.Text("${user.bank_account!.bic}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Name der Bank"),
                  pw.Text("${user.bank_account!.institute}"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
              "Ich versichere, dass ich die Übungsstunden entsprechend der Stundenaufstellung für den Verein {club_name} abgehalten habe."
                  .replaceFirst("{club_name}", club.name)),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(180),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Text("Übungsstunden"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_hours)} h"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Dauer pro Einheit"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_unit_duration)} h"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Einheiten"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_units)}"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Vergütung pro Einheit"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_rate)} Euro"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Vergütungsbetrag"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_sum)} Euro"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Verzichtserklärung",
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
              "Die mir zustehende Vergütung aus gemeinnütziger Tätigkeit soll nur in dem angegebenen Anteil ausgezahlt werden. "
                      "Den nicht ausgezahlten Betrag wende ich dem Verein {club_name} als Spende zu und bitte um "
                      "Erteilung einer entsprechenden Zuwendungsbestätigung."
                  .replaceFirst("{club_name}", club.name)),
          pw.SizedBox(height: 5),
          pw.Text("Gleichzeitig versichere ich hiermit, dass die Steuerbefreiung nach § 3 Nr. 26a EStG "
              "nicht bereits für eine andere ehrenamtliche Tätigkeit berücksichtigt wurde."),
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
                  pw.Text("Vergütungsbetrag"),
                  pw.Text("${NumberFormat.decimalPattern(locale).format(compensation_sum)} Euro"),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text("davon Auszahlungsbetrag"),
                  pw.Container(
                    height: 20,
                    decoration: boxInputDecoration,
                  ),
                ],
              ),
              pw.TableRow(children: [pw.SizedBox(height: 10)]),
              pw.TableRow(
                children: [
                  pw.Text("davon Zuwendungsspende"),
                  pw.Container(
                    height: 20,
                    decoration: boxInputDecoration,
                  ),
                ],
              ),
            ],
          ),
          pw.Spacer(),
          pw.Container(
            height: 50,
            padding: const pw.EdgeInsets.all(5),
            decoration: boxInputDecoration,
            child: pw.Text("Ort/Datum/Unterschrift des Übungsleiters", style: styleTinyBold),
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
        pw.Text(event.location!.name),
        pw.Text("${event.begin.fmtTime(context)}-${event.end.fmtTime(context)}"),
        pw.Text("${event.end.difference(event.begin).inMinutes}"),
      ],
    );
  }

  int eventsPerPage = 25;
  int pages = (event_list.length/eventsPerPage).ceil();

  for (int page = 0; page < pages; page++) {
    int startIndex = page * eventsPerPage;
    int endIndex = min(startIndex + eventsPerPage, event_list.length);
    List<Event> partial_events = event_list.sublist(startIndex, endIndex);

    doc.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                buildHeader(),
                pw.Text(
                  "Stundenaufstellung - Seite ${page + 1}",
                  textAlign: pw.TextAlign.center,
                  style: styleHeading,
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text("Datum", style: styleBold),
                        pw.Text("Tätigkeit", style: styleBold),
                        pw.Text("Trainingsort", style: styleBold),
                        pw.Text("Trainingszeit", style: styleBold),
                        pw.Text("Dauer", style: styleBold),
                      ],
                    ),
                    ...partial_events.map((event) => buildUnitRow(event)),
                  ],
                ),
                pw.Spacer(),
                pw.Container(
                  height: 40,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: boxInputDecoration,
                  child: pw.Text("Kommentar zur Stundenaufstellung", style: styleTinyBold),
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Container(
                          height: 40,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: boxInputDecoration,
                          child: pw.Text("Datum/Unterschrift des Übungsleiters", style: styleTinyBold),
                        )),
                    pw.Expanded(
                        child: pw.Container(
                          height: 40,
                          padding: const pw.EdgeInsets.all(5),
                          decoration: boxInputDecoration,
                          child: pw.Text("Datum/Unterschrift des Abteilungsleiters", style: styleTinyBold),
                        )),
                  ],
                ),
              ],
            ),
      ),
    );
  }

  doc.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          buildHeader(),
          pw.Text(
            "Freibetragserklärung",
            textAlign: pw.TextAlign.center,
            style: styleHeading,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Erklärung zur Vergütungsabrechnung bei Nutzung der Übungsleiterfreibetragsregelung "
                    "nach § 3 Nr. 26 EstG zwischen dem Verein {club_name}, vertreten "
                    "durch den 1. Vorsitzenden {club_chairman}, und dem/der Übungsleiter/in."
                .replaceFirst("{club_name}", club.name)
                .replaceFirst("{club_chairman}", club.chairman!),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Es besteht die Möglichkeit zur Nutzung des jeweiligen Freibetragsvolumens durch den Verein bis zum höchstmöglichen Freibetrag von derzeit 3.000 Euro pro Jahr. Bei Beachtung der sonstigen Vorgaben für diese steuerbegünstigte "
            "nebenberufliche Tätigkeit handelt es sich um einen persönlichen Steuerfreibetrag, den der nebenberuflich Beschäftigte personenbezogen "
            "bei der Zusammenarbeit mit Vereinen/Verbänden und sonstigen gemeinnützigen Organisationen für Vergütungsabrechnungen nutzen kann. "
            "Dadurch sind begünstigte Übungsleitertätigkeiten weitgehend von steuer- und sozialversicherungsrechtlichen Abgaben befreit.",
            textAlign: pw.TextAlign.justify,
            style: styleTiny,
          ),
          pw.SizedBox(height: 10),
          pw.Text("Ich bin als Übungsleiter/in für den Verein nur nebenberuflich tätig."),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text("Ja"),
              pw.SizedBox(width: 50),
              pw.Text("☐ "),
              pw.Text("Nein"),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("Für die Inanspruchnahme meines persönlichen Steuerfreibetrages im Jahr {fiskal_year} gebe ich an:"
              .replaceFirst("{fiskal_year}", fiskal_year.toString())),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Expanded(
                  child: pw.Column(children: [
                pw.Text(
                  "Ich versichere, dass ich neben meiner Übungsleitertätigkeit beim Verein "
                  "keine weiteren begünstigten Tätigkeiten nach § 3 Nr. 26 EStG ausübe bzw. ausgeübt habe. "
                  "Eine auch teilweise Inanspruchnahme meines persönlichen Steuerfreibetrags bei anderen Dritten ist somit nicht erfolgt.",
                  textAlign: pw.TextAlign.justify,
                ),
              ])),
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
                    "Neben meiner Tätigkeit für den Verein werden weitere Übungsleitertätigkeit(en) "
                    "für nachfolgende Einrichtung(en) ausgeübt. Hierfür wird dort bereits vom persönlichen "
                    "Steuerfreibetrag nach § 3 Nr. 26 EStG ein anteiliger Betrag für die dortigen Vergütungen genutzt.",
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
                            pw.Text("Name", style: styleTinyBold),
                            pw.Text("Anschrift", style: styleTinyBold),
                            pw.Text("Betrag (Euro)", style: styleTinyBold),
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
              )),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Einreichung von Lizenzen für die Vereinspauschale",
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
                  pw.Text("Hauptlizenz"),
                  pw.Text(user.license_main == null ? "" : "${user.license_main!.name} (${user.license_main!.number})"),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Zusatzlizenz"),
                  pw.Text(
                      user.license_extra == null ? "" : "${user.license_extra!.name} (${user.license_extra!.number})"),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
              "Für das Jahr {fiskal_year} sollen diese Lizenzen vom Verein {club_name} für die Vereinspauschale nach den Sportförderrichtlinien eingereicht werden."
                  .replaceFirst("{fiskal_year}", fiskal_year.toString())
                  .replaceFirst("{club_name}", club.name)),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text("Die Lizenz soll voll für den Verein verwendet werden."),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("☐ "),
              pw.Text("Die Lizenz soll mit dem Verein geteilt werden."),
            ],
          ),
          pw.Spacer(),
          pw.Container(
            height: 50,
            padding: const pw.EdgeInsets.all(5),
            decoration: boxInputDecoration,
            child: pw.Text("Ort/Datum/Unterschrift des Übungsleiters", style: styleTinyBold),
          ),
        ],
      ),
    ),
  );
  // TODO fix name
  exportPDF('trainer_accounting', await doc.save());
}
