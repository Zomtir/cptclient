import 'package:flutter/material.dart';

import 'material/app/AppBody.dart';
import 'material/app/AppInfoRow.dart';
import 'material/app/AppSlotTile.dart';

import 'json/session.dart';
import 'json/slot.dart';

class ClassMemberPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isModerator = false;
  
  ClassMemberPage({Key? key, required this.session, required this.slot, required this.onUpdate, required this.isDraft}) : super(key: key);

  @override
  ClassMemberPageState createState() => ClassMemberPageState();
}

class ClassMemberPageState extends State<ClassMemberPage> {

  ClassMemberPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Slot configuration"),
      ),
      body: AppBody(
        children: [
          if (widget.slot.id != 0) Row(
            children: [
              Expanded(
                child: AppSlotTile(
                  onTap: (slot) => {},
                  slot: widget.slot,
                ),
              ),
            ],
          ),
          //Text(widget.slot.status!.toString()),
          Column(
            children: [
              AppInfoRow(
                info: Text("Register"),
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {  },
                ),
              ),
              AppInfoRow(
                info: Text("Participate"),
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
