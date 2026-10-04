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
          balance.$5 > 0 ? "☐" : "",
          textAlign: pw.TextAlign.center,
          style: styleContent,
        ),
        pw.Text(
          balance.$5 > 0 ? "☐" : "",
          textAlign: pw.TextAlign.center,
          style: styleContent,
        ),
        pw.Text("", style: styleContent),
      ],
    );
  }

  pw.TableRow buildSeparator() {
    return pw.TableRow(
      children: List.generate(
        6,
        (_) => pw.Container(
          height: 2,
          color: PdfColors.black,
        ),
      ),
    );
  }

  int entriesPerPage = 20;
  List<(int, int)> pageRanges = [];

  int startIndex = 0;

  // Compute the page count while having all items of a user on a single page
  while (startIndex < balance_list.length) {
    int endIndex = min(startIndex + entriesPerPage, balance_list.length);

    while (endIndex > startIndex &&
        endIndex < balance_list.length &&
        balance_list[endIndex - 1].$1 == balance_list[endIndex].$1) {
      endIndex--;
    }

    // If user has more than entriesPerPage entries, split the entries across pages.
    if (endIndex == startIndex) {
      endIndex = min(startIndex + entriesPerPage, balance_list.length);
    }

    pageRanges.add((startIndex, endIndex));
    startIndex = endIndex;
  }

  int pages = pageRanges.length;

  for (int page = 0; page < pages; page++) {
    final (startIndex, endIndex) = pageRanges[page];
    final partialList = balance_list.sublist(startIndex, endIndex);

    final partialRows = <pw.TableRow>[];

    // Separate users visually
    int userStart = 0;
    while (userStart < partialList.length) {
      int userEnd = userStart + 1;

      while (userEnd < partialList.length && partialList[userEnd].$1 == partialList[userStart].$1) {
        userEnd++;
      }

      for (int i = userStart; i < userEnd; i++) {
        partialRows.add(buildRow(partialList[i]));
      }

      if (userEnd < partialList.length) {
        partialRows.add(buildSeparator());
      }

      userStart = userEnd;
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(40),
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
                ...partialRows,
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
