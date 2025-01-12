import 'package:cptclient/material/design/AppInputDecoration.dart';
import 'package:flutter/material.dart';

class TextWrapList extends StatefulWidget {
  const TextWrapList({super.key, required this.text, required this.onChanged});

  final String text;
  final Function(String) onChanged;

  @override
  State<StatefulWidget> createState() => TextWrapListState();
}

class TextWrapListState extends State<TextWrapList> {
  List<String> _list = [];

  final TextEditingController _ctrlInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _list = cleanSplit(widget.text);
  }

  List<String> cleanSplit(String text) {
    List<String> extraList = text.replaceAll(RegExp(r'\s+'), ' ').split(',');
    extraList = extraList.map((e) => e.trim()).toList();
    extraList = extraList.where((e) => e.isNotEmpty).toList();
    return extraList;
  }

  void addEntry(String entry) {
    List<String> extraList = cleanSplit(_ctrlInput.text);

    setState(() {
      _list.addAll(extraList);
      _list.sort();
      _ctrlInput.clear();
    });

    widget.onChanged(_list.join(','));
  }

  void removeEntry(int index) {
    setState(() => _list.removeAt(index));
    widget.onChanged(_list.join(','));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          maxLines: 1,
          controller: _ctrlInput,
          onEditingComplete: () => addEntry(_ctrlInput.text),
          decoration: AppInputDecoration(
            suffixIcon: IconButton(
              onPressed: () => addEntry(_ctrlInput.text),
              icon: const Icon(Icons.add),
            ),
          ),
        ),
        Wrap(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.value),
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () => removeEntry(entry.key),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
