import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

void messageText(String message) {
  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void messageStatus(bool success) {
  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(success ? AppLocalizations.of(context)!.responseSuccess : AppLocalizations.of(context)!.responseFail)));
}

void messageFailureOnly(bool success) {
  if (success) return;
  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
}
