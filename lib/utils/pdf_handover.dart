import 'dart:math';

import 'package:cptclient/json/event.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/utils/export.dart';
import 'package:cptclient/utils/format.dart';
import 'package:cptclient/utils/item_balance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void handover_protocol_pdf(BuildContext context, Event event, List<ItemBalance> totalBalance) async {
  int entriesPerPage = 28;
  List<(int, int)> pageRanges = [];

  // First page has 6 less entries for the header
  int startIndex = 0;
  int pageOffset = 6;

  // Compute the page count while having all items of a user on a single page
  while (startIndex < totalBalance.length) {
    int endIndex = min(startIndex + entriesPerPage - pageOffset, totalBalance.length);

    while (endIndex > startIndex &&
        endIndex < totalBalance.length &&
        totalBalance[endIndex - 1].$1 == totalBalance[endIndex].$1) {
      endIndex--;
    }

    // If user has more than entriesPerPage entries, split the entries across pages.
    if (endIndex == startIndex) {
      endIndex = min(startIndex + entriesPerPage, totalBalance.length);
    }

    pageRanges.add((startIndex, endIndex));
    startIndex = endIndex;
    pageOffset = 0;
  }

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

  int pages = pageRanges.length;

  for (int page = 0; page < pages; page++) {
    final (startIndex, endIndex) = pageRanges[page];
    final partialBalance = totalBalance.sublist(startIndex, endIndex);
    final partialRows = <pw.TableRow>[];

    // Separate users visually
    int userStart = 0;
    while (userStart < partialBalance.length) {
      int userEnd = userStart + 1;

      while (userEnd < partialBalance.length && partialBalance[userEnd].$1 == partialBalance[userStart].$1) {
        userEnd++;
      }

      for (int i = userStart; i < userEnd; i++) {
        partialRows.add(buildRow(partialBalance[i], styleContent));
      }

      if (userEnd < partialBalance.length) {
        partialRows.add(buildSeparator());
      }

      userStart = userEnd;
    }

    doc.addPage(buildPage(context, event, page, pages, totalBalance, partialRows, styleHeading, styleBold));
  }

  exportPDF('handover_protocol_${event.id}', await doc.save());
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

pw.TableRow buildRow(ItemBalance balance, pw.TextStyle styleContent) {
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

pw.Widget buildHeader(BuildContext context, Event event, List<ItemBalance> totalBalance, pw.TextStyle styleHeading) {
  var (uniqueUsers, miscItems, groupedItems) = evalBalance(totalBalance);

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Text(
        "${AppLocalizations.of(context)!.equipment} - ${AppLocalizations.of(context)!.labelTransferProtocol}",
        textAlign: pw.TextAlign.center,
        style: styleHeading,
      ),
      pw.Text(event.title, textAlign: pw.TextAlign.center),
      pw.Table(
        columnWidths: {
          0: const pw.FixedColumnWidth(120),
          1: const pw.FlexColumnWidth(),
        },
        children: [
          pw.TableRow(
            children: [
              pw.Text("${AppLocalizations.of(context)!.dateFrame}:"),
              pw.Text("${compressDate(context, event.begin, event.end)}"),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Text("${AppLocalizations.of(context)!.eventLocation}:"),
              pw.Text("${event.location?.name ?? ''}"),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Text("${AppLocalizations.of(context)!.labelPrepared}:"),
              pw.Text("$uniqueUsers"),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Text("${AppLocalizations.of(context)!.labelNeeded}:"),
              pw.Text(
                "${groupedItems.entries.map((e) => '${e.value.$2} × ${e.key.name}').join(', ')}"
                ", $miscItems x ${AppLocalizations.of(context)!.labelMiscellaneous}",
              ),
            ],
          ),
        ],
      ),
      pw.Container(height: 10),
    ],
  );
}

pw.Page buildPage(
  BuildContext context,
  Event event,
  int page,
  int pages,
  List<ItemBalance> totalBalance,
  List<pw.TableRow> rows,
  pw.TextStyle styleHeading,
  pw.TextStyle styleBold,
) {
  return pw.Page(
    pageFormat: PdfPageFormat.a4.landscape,
    margin: const pw.EdgeInsets.fromLTRB(40, 30, 40, 40),
    build: (pw.Context pwcontext) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (page == 0) buildHeader(context, event, totalBalance, styleHeading),
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
            ...rows,
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
  );
}
