import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void messageText(String message) {
  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

bool handleFailedResponse(http.Response response) {
  if (response.statusCode == 200) return false;

  BuildContext? context = navi.naviKey.currentState?.overlay?.context;
  if (context == null) return true;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${AppLocalizations.of(context)!.actionRequest} "
  "${AppLocalizations.of(context)!.statusHasFailed}"
    "(Error ${AppLocalizations.of(context)!.actionSubmission} ${response.statusCode}")));
  return true;
}
