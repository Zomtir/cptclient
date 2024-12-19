import 'package:cptclient/core/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void messageSuccess(bool success) {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.responseSuccess)));
  print("Server Request: $success");
}

void messageFailureOnly(bool success) {
  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.submissionFail)));
}