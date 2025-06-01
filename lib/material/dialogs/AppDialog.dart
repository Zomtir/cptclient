import 'package:cptclient/material/design/AppBoxDecoration.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

Future<Result<T>?> showAppDialog<T>({
  required BuildContext context,
  required Widget widget,
  double maxWidth = 600,
}) async {
  return showDialog<Result<T>>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: widget,
        maxWidth: maxWidth,
      );
    },
  );
}

void useAppDialog<T>({
  required BuildContext context,
  required Widget widget,
  required Function(T) onChanged,
}) async {
  final response = await showAppDialog<T>(
    context: context,
    widget: widget,
  );

  if (response case Success(:T value)) {
    onChanged(value);
  }
}

class AppDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppDialog({required this.child, this.maxWidth = 600});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.3),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                decoration: const AppBoxDecoration(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                margin: const EdgeInsets.all(5.0),
                child: child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
