import 'dart:math';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/utils/datetime.dart';
import 'package:cptclient/utils/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

typedef ItemBalance = (
  User user,
  Item item,
  int count_target,
  int count_current,
  int count_missing,
);

void handover_protocol_pdf(BuildContext context, Event event, List<ItemBalance> balance_list) async {
  var docTheme = pw.ThemeData.withFont(
    base: pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/SourceSansPro/source-sans-pro.regular.ttf",
      ),
    ),
    bold: pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/SourceSansPro/source-sans-pro.bold.ttf",
      ),
    ),
    italic: pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/SourceSansPro/source-sans-pro.italic.ttf",
      ),
    ),
    boldItalic: pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/SourceSansPro/source-sans-pro.bold-italic.ttf",
      ),
    ),
  );

  pw.TextStyle styleHeading = pw.TextStyle(
    fontSize: 20,
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle styleBold = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
  );

  pw.TextStyle styleContent = pw.TextStyle(
    fontSize: 14,
  );

  final doc = pw.Document(
    theme: docTheme,
  );

  pw.TableRow buildRow(ItemBalance balance) {
    return pw.TableRow(
      children: [
        pw.Text("${balance.$1.firstname} ${balance.$1.lastname}", style: styleContent),
        pw.Text("${balance.$2.name}", style: styleContent),
        pw.Text("${balance.$5}", textAlign: pw.TextAlign.center, style: styleContent),
        pw.Text(
          "☐",
          textAlign: pw.TextAlign.center,
          style: styleContent,
        ),
        pw.Text(
          "☐",
          textAlign: pw.TextAlign.center,
          style: styleContent,
        ),
        pw.Text("", style: styleContent),
      ],
    );
  }

  int entriesPerPage = 20;
  int pages = (balance_list.length / entriesPerPage).ceil();

  for (int page = 0; page < pages; page++) {
    int startIndex = page * entriesPerPage;
    int endIndex = min(startIndex + entriesPerPage, balance_list.length);
    List<ItemBalance> partial_list = balance_list.sublist(startIndex, endIndex);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context pwcontext) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              "${AppLocalizations.of(context)!.equipment} - ${AppLocalizations.of(context)!.labelTransferProtocol}",
              textAlign: pw.TextAlign.center,
              style: styleHeading,
            ),
            pw.Text(event.title),
            pw.Text(event.begin.fmtDate(context)),
            pw.Text(event.location?.name ?? ''),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700),
              columnWidths: {
                0: const pw.FixedColumnWidth(100),
                1: const pw.FixedColumnWidth(120),
                2: const pw.FixedColumnWidth(32),
                3: const pw.FixedColumnWidth(32),
                4: const pw.FixedColumnWidth(32),
                5: const pw.FixedColumnWidth(110),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Text(
                      AppLocalizations.of(context)!.user,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      AppLocalizations.of(context)!.item,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      AppLocalizations.of(context)!.labelNeeded,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      AppLocalizations.of(context)!.labelIssuance,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      AppLocalizations.of(context)!.labelReturn,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      AppLocalizations.of(context)!.labelComment,
                      style: styleBold,
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
                ...partial_list.map((balance) => buildRow(balance)),
              ],
            ),
            pw.Spacer(),
            pw.Text(
              "${AppLocalizations.of(context)!.labelPage} ${page + 1} / $pages",
              style: styleBold,
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  exportPDF('handover_protocol_${event.id}', await doc.save());
}
