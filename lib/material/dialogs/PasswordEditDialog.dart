import 'package:cptclient/json/credential.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
import 'package:cptclient/utils/message.dart';
import 'package:flutter/material.dart';

class PasswordEditDialog extends StatefulWidget {
  final Credential? initialValue;
  final int minLength = 6;
  final int maxLength = 50;
  final VoidCallback? onDelete;
  final VoidCallback? onReset;
  final Function(Credential)? onConfirm;

  PasswordEditDialog({super.key, required this.initialValue, this.onDelete, this.onReset, this.onConfirm});

  @override
  PasswordEditDialogState createState() => PasswordEditDialogState();
}

class PasswordEditDialogState extends State<PasswordEditDialog> {
  late Credential currentValue;
  final TextEditingController _ctrlSalt = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();

  PasswordEditDialogState();

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue ?? Credential(password: '', salt: crypto.generateHex(16));
    _ctrlSalt.text = currentValue.salt!;
    _ctrlPassword.text = currentValue.password!;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        children: [
          AppInfoRow(
            info: AppLocalizations.of(context)!.userSalt,
            child: TextField(
              maxLines: 1,
              controller: _ctrlSalt,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    _ctrlSalt.text = crypto.generateHex(16);
                    currentValue.salt = _ctrlSalt.text;
                  }),
                  icon: Icon(Icons.refresh),
                ),
              ),
            ),
          ),
          AppInfoRow(
            info: AppLocalizations.of(context)!.userPassword,
            child: TextField(
              obscureText: true,
              maxLines: 1,
              controller: _ctrlPassword,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.userPasswordChange,
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    _ctrlPassword.text = "";
                  }),
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onReset != null)
          IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {
              widget.onReset?.call();
              Navigator.pop(context);
            },
          ),
        if (widget.onConfirm != null)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if ((currentValue.salt?.length ?? 0) != 32) {
                messageText("${AppLocalizations.of(context)!.userSalt} ${AppLocalizations.of(context)!.isInvalid}: x != 32");
                return;
              }
              if ((currentValue.password?.length ?? 0) < widget.minLength) {
                messageText("${AppLocalizations.of(context)!.userPassword} ${AppLocalizations.of(context)!.isInvalid}: x < ${widget.minLength}");
                return;
              }
              if ((currentValue.password?.length ?? 0) > widget.maxLength) {
                messageText("${AppLocalizations.of(context)!.userPassword} ${AppLocalizations.of(context)!.isInvalid}: x > ${widget.maxLength}");
                return;
              }
              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
