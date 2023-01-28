import 'package:flutter/material.dart';

import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/SelectItem.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'static/navigation.dart' as navi;
import 'static/server.dart' as server;
import 'static/serverSlotCasual.dart' as server;
import 'json/session.dart';
import 'json/user.dart';

class EnrollPage extends StatefulWidget {
  final Session session;

  EnrollPage({Key? key, required this.session}) : super(key: key) {
    if (session.token == "" || session.slot == null)
      navi.logout();
  }

  @override
  State<StatefulWidget> createState() => EnrollPageState();
}

class EnrollPageState extends State<EnrollPage> {
  List<User> candidates = [];
  List<User> candidatesFiltered = [];
  List<User> participants = [];

  TextEditingController _ctrlMemberFilter = TextEditingController();
  SelectController _ctrlMemberSelect = SelectController();
  SelectController _ctrlParticipantSelect = SelectController();

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async
  {
    candidates = await server.slot_candidates(widget.session);
    participants = await server.slot_participants(widget.session);

    var setP = Set.from(participants);
    var setC = Set.from(candidates);
    candidates = List.from(setC.difference(setP));

    setState(() {
      candidates.sort();
      candidatesFiltered = candidates;
      participants.sort();
    });
  }

  void _filterCandidates(String filter) {
    setState(() {
      candidatesFiltered = candidates.where((User user) => user.key.contains(new RegExp(filter, caseSensitive: false))).toList();
    });
  }

  void _unfilterCandidates() {
    setState(() {
      candidatesFiltered = candidates;
      _ctrlMemberFilter.clear();
      _ctrlMemberSelect.deselect();
    });
  }

  void _submitMember(String filter) {
    if (candidatesFiltered.length == 1)
      _enrolMember(candidatesFiltered[0]);
  }

  void _enrolMember(User user) async {
    final response = await http.head(
      Uri.http(server.serverURL, 'slot_enrol', {'user': user.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    setState(() {
      candidates.remove(user);
      participants.add(user);
      participants.sort();
      candidatesFiltered = candidates;
    });
    _ctrlMemberFilter.clear();
    _ctrlMemberSelect.deselect();
    _ctrlParticipantSelect.deselect();
  }

  void _dimissMember(User user) async {
    final response = await http.head(
      Uri.http(server.serverURL, 'slot_dismiss', {'user': user.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    setState(() {
      participants.remove(user);
      candidates.add(user);
      candidates.sort();
      candidatesFiltered = candidates;
    });
    _ctrlMemberFilter.clear();
    _ctrlMemberSelect.deselect();
    _ctrlParticipantSelect.deselect();
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Enroll for a time slot"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => navi.logout(),
          )
        ],
      ),
      body: AppBody(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("[${widget.session.slot!.id.toString()}] ${widget.session.slot!.title}",
                style: TextStyle(fontWeight: FontWeight.bold),),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule),
              Text("${DateFormat("yyyy-MM-dd HH:mm").format(widget.session.slot!.begin)} - ${DateFormat("yyyy-MM-dd HH:mm").format(widget.session.slot!.end)}"),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.room),
              Text(widget.session.slot!.location!.title),
            ],
          ),
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          Text("Candidates",
            style: TextStyle(fontWeight: FontWeight.bold),),
          TextField(
            autofocus: true,
            maxLines: 1,
            focusNode: FocusNode(),
            controller: _ctrlMemberFilter,
            onChanged: _filterCandidates,
            onSubmitted: _submitMember,
            decoration: InputDecoration(
              hintText: "Filter member ID",
              suffixIcon: IconButton(
                onPressed: _unfilterCandidates,
                icon: Icon(Icons.clear),
              ),
            ),
          ),
          _buildMemberList(_ctrlMemberSelect, candidatesFiltered, _enrolMember),
          Divider(
            height: 30,
            thickness: 5,
            color: Colors.black,
          ),
          Text("Participants",
            style: TextStyle(fontWeight: FontWeight.bold),),
          _buildMemberList(_ctrlParticipantSelect, participants, _dimissMember),
        ],
      ),
    );
  }

  ListView _buildMemberList(SelectController _ctrl, List<User> members, Function(User) _onConfirmed) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          child: SelectItem(
            onSelected: () =>
              setState(() {
                _ctrl.select(index);
              }),
            onConfirmed: () => _onConfirmed(members[index]),
            child: Container(
              child: ListTile(
                title: Text("${members[index].lastname} ${members[index].firstname}"),
                subtitle: Text("${members[index].key}"),
              ),
              decoration: _ctrl.isSelected(index)
                  ? BoxDecoration(color: Colors.grey[300])
                  : BoxDecoration(),
            ),
          ),
        );
      },
    );
  }

}
