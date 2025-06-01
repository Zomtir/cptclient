import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/widgets/AppButton.dart';
import 'package:cptclient/utils/message.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class TextEdit extends StatefulWidget {
  TextEdit({
    super.key,
    required this.text,
    required this.minLength,
    required this.maxLength,
  }) {
    assert(
      (minLength < maxLength),
      'minLength $minLength must be less or equal than maxLength $maxLength.',
    );
  }

  final String text;
  final int minLength;
  final int maxLength;

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  final TextEditingController _ctrlText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrlText.text = widget.text;
  }

  void _handleConfirm() {
    if (_ctrlText.text.length < widget.minLength) {
      messageText("Too short");
      return;
    }
    if (_ctrlText.text.length > widget.maxLength) {
      messageText("Too long");
      return;
    }

    Navigator.pop(context, Success(_ctrlText.text));
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextField(
            maxLines: 1,
            controller: _ctrlText,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AppButton(
              onPressed: _handleCancel,
              text: AppLocalizations.of(context)!.actionCancel,
            ),
            Spacer(),
            AppButton(
              onPressed: _handleConfirm,
              text: AppLocalizations.of(context)!.actionConfirm,
            ),
          ],
        ),
      ],
    );
  }
}
