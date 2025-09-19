import 'package:cptclient/material/design/AppBoxDecoration.dart';
import 'package:flutter/material.dart';

Future<void> useAppDialog({
  required BuildContext context,
  required Widget child,
}) async {
  await showDialog(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return child;
    },
  );
}

class AppDialog extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;

  const AppDialog({
    super.key,
    this.maxWidth = 600,
    required this.child,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.3),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            decoration: const AppBoxDecoration(),
            padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 16.0),
            margin: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    (title != null) ? Expanded(child: title!) : Spacer(),
                    ...?actions,
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
