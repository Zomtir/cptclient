import 'package:cptclient/utils/string.dart';
import 'package:flutter/material.dart';

class CategoryDisplay extends StatelessWidget {
  CategoryDisplay({super.key, required String text}) : _list = cleanSplit(text);

  final List<String> _list;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _list
          .asMap()
          .entries
          .map(
            (entry) => Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  color: Colors.black38,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(entry.value),
            ),
          )
          .toList(),
    );
  }
}
