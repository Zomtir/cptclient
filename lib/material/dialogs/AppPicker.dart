import 'package:cptclient/material/AppButton.dart';
import 'package:cptclient/material/AppDialog.dart';
import 'package:cptclient/material/panels/SearchablePanel.dart';
import 'package:cptclient/structs/SelectionData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<T?> showAppPicker<T>({
  required BuildContext context,
  required items,
  T? initial,
  required builder,
  required filter,
}) async {
  Widget picker = AppPicker<T>(
    items: items,
    initial: initial,
    builder: builder,
    filter: filter,
  );

  return showDialog<T>(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppDialog(
        child: picker,
        maxWidth: 470,
      );
    },
  );
}

class AppPicker<T> extends StatefulWidget {
  AppPicker({
    super.key,
    required this.items,
    required this.initial,
    required this.builder,
    required this.filter,
  });

  final List<T> items;
  final T? initial;
  final Widget Function(T) builder;
  final List<T> Function(List<T>, String) filter;

  @override
  State<AppPicker<T>> createState() => _AppPickerState<T>();
}

class _AppPickerState<T> extends State<AppPicker<T>> {
  late SelectionData<T> _data;

  @override
  void initState() {
    super.initState();

    _data = SelectionData<T>(
        available: widget.items,
        selected: [],
        onSelect: _handleConfirm,
        onDeselect: (item)=>{},
        filter: widget.filter
    );
  }

  List<T> _handleConfirm(T item) {
    if (item == widget.initial) {
      _handleCancel();
    } else {
      Navigator.pop(context, item);
    }

    return widget.items;
  }

  void _handleCancel() {
    Navigator.pop(context, widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchablePanel<T>(
          dataModel: _data,
          builder: widget.builder,
        ),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              AppButton(
                onPressed: _handleCancel,
                text: AppLocalizations.of(context)!.actionCancel,
              ),
            ],
          ),
        )
      ],
    );
  }
}
