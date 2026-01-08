import 'package:cptclient/json/credential.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/AppDialog.dart';
import 'package:cptclient/material/widgets/AppInfoRow.dart';
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
  final TextEditingController _ctrlSalt = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();

  PasswordEditDialogState();

  @override
  void initState() {
    super.initState();
    Credential currentValue = widget.initialValue ?? Credential(password: '', salt: crypto.generateHex(16));
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
              if (_ctrlSalt.text.length != 32) {
                messageText("${AppLocalizations.of(context)!.userSalt} ${AppLocalizations.of(context)!.statusIsInvalid}: x != 32");
                return;
              }
              if (_ctrlPassword.text.length < widget.minLength) {
                messageText("${AppLocalizations.of(context)!.userPassword} ${AppLocalizations.of(context)!.statusIsInvalid}: x < ${widget.minLength}");
                return;
              }
              if (_ctrlPassword.text.length > widget.maxLength) {
                messageText("${AppLocalizations.of(context)!.userPassword} ${AppLocalizations.of(context)!.statusIsInvalid}: x > ${widget.maxLength}");
                return;
              }
              Credential currentValue = Credential(password: _ctrlPassword.text, salt: _ctrlSalt.text);
              widget.onConfirm?.call(currentValue);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
