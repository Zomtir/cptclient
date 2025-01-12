import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttributeField<T extends FieldInterface> extends StatelessWidget {
  final T? attribute;
  final Future<void> Function() onCreate;
  final Future<void> Function(T) onEdit;
  final Future<void> Function() onDelete;
  final Widget Function(BuildContext, Future<void> Function(T)) builder;

  AttributeField({
    super.key,
    required this.attribute,
    required this.onCreate,
    required this.onEdit,
    required this.onDelete,
    required this.builder,
  });

  _handleEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => builder(context, onEdit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (attribute == null)
          ListTile(
            title: Text(AppLocalizations.of(context)!.labelMissing),
            trailing: IconButton(onPressed: onCreate, icon: Icon(Icons.add)),
          ),
        if (attribute != null)
          ListTile(
            title: attribute!.buildEntry(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => _handleEdit(context), icon: Icon(Icons.edit)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
              ],
            ),
            onTap: () => _handleEdit(context),
          ),
      ],
    );
  }
}