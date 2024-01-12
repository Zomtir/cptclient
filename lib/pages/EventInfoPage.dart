import 'package:cptclient/json/session.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppInfoRow.dart';
import 'package:cptclient/static/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO rename to SlotInfoPage and include courseInfo if available
class EventInfoPage extends StatefulWidget {
  final Session session;
  final Slot slot;

  EventInfoPage({
    super.key,
    required this.session,
    required this.slot,
  });

  @override
  EventInfoPageState createState() => EventInfoPageState();
}

class EventInfoPageState extends State<EventInfoPage> {

  EventInfoPageState();

  void _handleLikeAdd() async {
    //await api_regular.event_like_add(widget.session, widget.slot);
  }

  void _handleLikeRemove() async {
    //await api_regular.event_like_remove(widget.session, widget.slot);
  }

  void _handleParticipationAdd() async {
    //await api_regular.event_participant_add(widget.session, widget.slot);
  }

  void _handleParticipationRemove() async {
    //await api_regular.event_participant_remove(widget.session, widget.slot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageEventInfo),
      ),
      body: AppBody(
        children: [
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotKey),
            child: Text(widget.slot.key),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotTitle),
            child: Text(widget.slot.title),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotBegin),
            child: Text(niceDateTime(widget.slot.begin)),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotEnd),
            child: Text(niceDateTime(widget.slot.end)),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotLocation),
            child: Text(widget.slot.location!.title),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotPublic),
            child: Checkbox(
              value: widget.slot.public,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotScrutable),
            child: Checkbox(
              value: widget.slot.scrutable,
              onChanged: null,
            ),
          ),
          AppInfoRow(
            info: Text(AppLocalizations.of(context)!.slotNote),
            child: Text(widget.slot.note),
          ),
          Divider(),
          IconButton(icon: Icon(Icons.star), onPressed: _handleLikeAdd),
          IconButton(icon: Icon(Icons.group_add), onPressed: _handleParticipationAdd),
        ],
      ),
    );
  }
}
