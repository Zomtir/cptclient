import 'package:cptclient/json/stock.dart';
import 'package:cptclient/material/widgets/RoundBox.dart';
import 'package:flutter/material.dart';

class AppStockTile extends StatelessWidget {
  final Stock stock;
  final List<Widget> trailing;

  const AppStockTile({
    super.key,
    required this.stock,
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    return RoundBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(message: "[${stock.id}]", child: Icon(Icons.info)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${stock.club.name}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${stock.item.name}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${stock.storage}",
                    style: TextStyle(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
