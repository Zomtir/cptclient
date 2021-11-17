import 'package:flutter/material.dart';
import 'material/app/AppBody.dart';
import 'material/SelectItem.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'static/navigation.dart' as navi;
import 'json/session.dart';
import 'json/member.dart';

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
  List<Member> candidates = [];
  List<Member> candidatesFiltered = [];
  List<Member> participants = [];

  TextEditingController _ctrlMemberFilter = TextEditingController();
  SelectController _ctrlMemberSelect = SelectController();
  SelectController _ctrlParticipantSelect = SelectController();

  EnrollPageState();

  @override
  void initState() {
    super.initState();
    _loadInit();
  }

  void _loadInit() async
  {
    await _getParticipants();
    await _getCandidates();

    var setP = Set.from(participants);
    var setC = Set.from(candidates);
    candidates = List.from(setC.difference(setP));

    setState(() {
      candidates.sort();
      candidatesFiltered = candidates;
      participants.sort();
    });
  }

  Future<void> _getParticipants() async {
    final response = await http.get(
      Uri.http(navi.server, 'slot_participants'),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode == 401) {
      Navigator.pop(context);
      return;
    }

    if (response.statusCode != 200) return;

    Iterable l = json.decode(response.body);

    participants = List<Member>.from(l.map((model) => Member.fromJson(model)));
  }

  Future<void> _getCandidates() async {
    final response = await http.get(
      Uri.http(navi.server, 'slot_candidates'),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode == 401) {
      Navigator.pop(context);
      return;
    }

    if (response.statusCode != 200)
      return;

    Iterable l = json.decode(response.body);

    candidates = List<Member>.from(l.map((model) => Member.fromJson(model)));
  }

  void _filterCandidates(String filter) {
    setState(() {
      candidatesFiltered = candidates.where((Member member) => member.key.contains(new RegExp(filter, caseSensitive: false))).toList();
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

  void _enrolMember(Member member) async {
    final response = await http.head(
      Uri.http(navi.server, 'slot_enrol', {'user': member.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    setState(() {
      candidates.remove(member);
      participants.add(member);
      participants.sort();
      candidatesFiltered = candidates;
    });
    _ctrlMemberFilter.clear();
    _ctrlMemberSelect.deselect();
    _ctrlParticipantSelect.deselect();
  }

  void _dimissMember(Member member) async {
    final response = await http.head(
      Uri.http(navi.server, 'slot_dismiss', {'user': member.id.toString()}),
      headers: {
        'Token': widget.session.token,
      },
    );

    if (response.statusCode != 200) return;

    setState(() {
      participants.remove(member);
      candidates.add(member);
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

  ListView _buildMemberList(SelectController _ctrl, List<Member> members, Function(Member) _onConfirmed) {
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
