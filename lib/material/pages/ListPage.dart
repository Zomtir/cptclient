import 'package:cptclient/material/AppBody.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:flutter/material.dart';

class ListPage<T extends FieldInterface> extends StatefulWidget {
  final String title;
  final Widget tile;
  final Future<List<T>> Function() onCallList;

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
    List<T> list = await widget.onCallList();
    list.sort();

    setState(() {
      _list = list;
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
            items: this._list,
            itemBuilder: (T item) => item.buildTile(),
          ),
        ],
      ),
    );
  }
}
