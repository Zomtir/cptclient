

void messageSuccess(bool success) {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.responseSuccess)));
  print("Server Request: $success");
}