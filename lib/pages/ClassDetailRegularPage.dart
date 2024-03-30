import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/material/tiles/AppEventTile.dart';
import 'package:flutter/material.dart';

class ClassMemberPage extends StatefulWidget {
  final Session session;
  final Event event;
  final void Function() onUpdate;
  final bool isDraft;
  final bool isModerator = false;
  
  ClassMemberPage({super.key, required this.session, required this.event, required this.onUpdate, required this.isDraft});

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
        title: Text("Event configuration"),
      ),
      body: AppBody(
        children: [
          if (!widget.isDraft) AppEventTile(
            event: widget.event,
          ),
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
