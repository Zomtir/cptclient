import 'package:cptclient/json/affiliation.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppAffiliationTile extends StatelessWidget {
  final Affiliation affiliation;
  final List<Widget> trailing;

  const AppAffiliationTile({
    super.key,
    required this.affiliation,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.card_membership),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                affiliation.organisation!.buildEntry(),
                affiliation.user!.buildEntry(),
                Text(
                    "${AppLocalizations.of(context)!.affiliationMemberIdentifier}: ${affiliation.member_identifier ?? AppLocalizations.of(context)!.undefined}"),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
