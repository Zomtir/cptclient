import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/layouts/AppBody.dart';
import 'package:cptclient/material/layouts/AppListView.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';

class ListPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Widget tile;
  final Future<Result<List<T>>> Function() onCallList;

  ListPage({
    super.key,
    required this.title,
    required this.tile,
    required this.onCallList,
  });

  @override
  ListPageState createState() => ListPageState<T>();
}

class ListPageState<T extends FieldInterface> extends State<ListPage<T>> {
  List<T> _list = [];

  ListPageState();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    Result<List<T>> result_list = await widget.onCallList();
    if (result_list is! Success) return;

    setState(() {
      _list = result_list.unwrap();
      _list.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AppBody(
        children: [
          widget.tile,
          AppListView<T>(
            items: _list,
            itemBuilder: (T item) => item.buildTile(context),
          ),
        ],
      ),
    );
  }
}
