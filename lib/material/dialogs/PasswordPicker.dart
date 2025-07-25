import 'package:cptclient/json/credential.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/layouts/AppInfoRow.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/crypto.dart' as crypto;
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class PasswordPicker extends StatefulWidget {
  final Credential? credits;
  final bool nullable;

  PasswordPicker({super.key, required this.credits, this.nullable = true});

  @override
  PasswordPickerState createState() => PasswordPickerState();
}

class PasswordPickerState extends State<PasswordPicker> {
  final TextEditingController _ctrlSalt = TextEditingController();
  final TextEditingController _ctrlPassword = TextEditingController();

  PasswordPickerState();

  @override
  void initState() {
    super.initState();
    _ctrlSalt.text = widget.credits?.salt ?? crypto.generateHex(16);
    _ctrlPassword.text = widget.credits?.password ?? '';
  }

  void _submit() async {
    if (_ctrlSalt.text.isEmpty || _ctrlSalt.text.length != 32) {
      messageText("${AppLocalizations.of(context)!.userSalt} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    if (_ctrlPassword.text.length < 6 || _ctrlPassword.text.length > 50) {
      messageText("${AppLocalizations.of(context)!.userPassword} ${AppLocalizations.of(context)!.isInvalid}");
      return;
    }

    Navigator.pop(context, Success(Credential(password: _ctrlPassword.text, salt: _ctrlSalt.text)));
  }

  @override
  Widget build(BuildContext context) {
    final Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppButton(
          onPressed: () => Navigator.pop(context),
          text: AppLocalizations.of(context)!.actionCancel,
        ),
        if (widget.nullable) Spacer(),
        if (widget.nullable)
          AppButton(
            onPressed: () => Navigator.pop(context, Success(null)),
            text: AppLocalizations.of(context)!.actionRemove,
          ),
        Spacer(),
        AppButton(
          onPressed: _submit,
          text: AppLocalizations.of(context)!.actionConfirm,
        ),
      ],
    );

    return Column(
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
        actions,
      ],
    );
  }
}
