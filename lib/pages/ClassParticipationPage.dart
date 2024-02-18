import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppSlotTile.dart';
import 'package:flutter/material.dart';

class ClassMemberPage extends StatefulWidget {
  final Session session;
  final Slot slot;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isModerator = false;
  
  ClassMemberPage({super.key, required this.session, required this.slot, required this.onUpdate, required this.isDraft});

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot configuration"),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) AppSlotTile(
            slot: widget.slot,
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
