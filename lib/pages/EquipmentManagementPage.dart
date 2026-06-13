import 'package:cptclient/api/admin/inventory/inventory.dart' as api_admin;
import 'package:cptclient/api/admin/inventory/item.dart' as api_admin;
import 'package:cptclient/api/anon/skill.dart' as api_anon;
import 'package:cptclient/api/regular/user/user.dart' as api_regular;
import 'package:cptclient/json/equipment.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/l10n/app_localizations.dart';
import 'package:cptclient/material/dialogs/PickerDialog.dart';
import 'package:cptclient/material/dialogs/StockEditDialog.dart';
import 'package:cptclient/material/widgets/AppBody.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class EquipmentManagementPage extends StatefulWidget {
  final UserSession session;

  EquipmentManagementPage({super.key, required this.session});

  @override
  EquipmentManagementPageState createState() => EquipmentManagementPageState();
}

class EquipmentManagementPageState extends State<EquipmentManagementPage> {
  bool _locked = true;
  User? _user;
  List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();

    _prepare();
  }

  Future<void> _prepare() async {
    Result<List<User>> result_users = await api_regular.user_list(
      widget.session,
    );
    if (result_users is! Success) return;

    User? user;
    await showDialog(
      context: context,
      builder: (context) => PickerDialog(
        items: result_users.unwrap(),
        onPick: (item) => user = item,
      ),
    );

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _user = user);
    await _update();
  }

  Future<void> _update() async {
    Result<List<Equipment>> result = await api_admin.equipment_list(
      widget.session,
      _user!,
      null,
      null,
    );
    if (result is! Success) return;

    setState(() {
      _equipments = result.unwrap();
      _equipments.sort();
      _locked = false;
    });
  }

  void _handleCreate() async {
    Result<List<Skill>> result_skills = await api_anon.skill_list();
    if (result_skills is! Success) return;

    Skill? skill;
    await showDialog(
      context: context,
      builder: (context) =>
          PickerDialog(items: result_skills.unwrap(), onPick: (s) => skill = s),
    );

    if (skill == null) return;

    Result<List<Item>> result_items = await api_admin.item_list(widget.session);
    if (result_items is! Success) return;

    Item? item;
    await showDialog(
      context: context,
      builder: (context) =>
          PickerDialog(items: result_items.unwrap(), onPick: (e) => item = e),
    );

    if (item == null) return;

    await api_admin.equipment_create(widget.session, _user!, skill!, item!, 1);
    _update();
  }

  void _handleDelete(Equipment equipment) async {
    await api_admin.equipment_delete(widget.session, equipment);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEquipmentManagement),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.actionCreate,
            onPressed: _handleCreate,
          ),
        ],
      ),
      body: AppBody(
        locked: _locked,
        maxWidth: 1000,
        minWidth: 1000,
        builder: (context) => [
          _user?.buildTile(
                context,
                trailing: [
                  IconButton(
                    onPressed: _prepare,
                    icon: Icon(Icons.refresh),
                    tooltip: AppLocalizations.of(context)!.user,
                  ),
                ],
              ) ??
              Container(),
          Divider(),
          DataTable(
            columns: [
              DataColumn(label: Text(AppLocalizations.of(context)!.item)),
              DataColumn(label: Text(AppLocalizations.of(context)!.skill)),
              DataColumn(
                label: Text(AppLocalizations.of(context)!.labelAmount),
              ),
            ],
            rows: List<DataRow>.generate(_equipments.length, (index) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(_equipments[index].item.buildEntry(context)),
                  DataCell(_equipments[index].skill.buildEntry(context)),
                  DataCell(
                    Row(
                      children: [
                        Text(_equipments[index].count.toString()),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => CountEditDialog(
                              initialValue: _equipments[index].count,
                              onConfirm: (int count) async {
                                await api_admin.equipment_edit(
                                  widget.session,
                                  _equipments[index].id,
                                  count,
                                );
                                _update();
                              },
                              onDelete: () => _handleDelete(_equipments[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
