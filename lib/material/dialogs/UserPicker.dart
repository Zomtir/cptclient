import 'package:cptclient/material/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:cptclient/material/AppListView.dart';
import 'package:cptclient/material/AppBody.dart';

import 'package:cptclient/json/user.dart';

void showUserPicker({
  required BuildContext context,
  required List<User> usersAvailable,
  List<User> usersHidden = const [],
  required Function(User) onSelect,

}) async {
  Widget dialog = UserPicker(
    usersAvailable: usersAvailable,
    usersHidden: usersHidden,
    onSelect: onSelect,
  );

  return showDialog(
    context: context,
    useSafeArea: false,
    builder: (BuildContext context) {
      return AppBody(
        children: [dialog],
      );
    },
  );
}

class UserPicker extends StatefulWidget {
  final List<User> usersAvailable;
  final List<User> usersHidden;
  final Function(User user) onSelect;

  UserPicker({
    Key? key,
    required this.usersAvailable,
    this.usersHidden = const [],
    required this.onSelect,
  }) : super(key: key);

  @override
  _UserPickerState createState() => new _UserPickerState();
}

class _UserPickerState extends State<UserPicker> {
  Set<User> usersVisible = {};
  List<User> usersFiltered = [];

  TextEditingController _ctrlUserFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    usersVisible = widget.usersAvailable.toSet().difference(widget.usersHidden.toSet());
    _unfilterUsers();
  }

  void _handleSelect(User user) {
    usersVisible.remove(user);
    setState(() {
      usersFiltered.remove(user);
    });
    widget.onSelect(user);
  }

  void _filterUsers(String filter) {
    setState(() {
      usersFiltered = usersVisible.where((User user) {
        Set<String> fragments = filter.toLowerCase().split(' ').toSet();
        List<String> searchspace = [user.key, user.firstname, user.lastname];

        for(var fragment in fragments) {
          bool matchedAny = false;
          for (var space in searchspace) {
            matchedAny = matchedAny || space.toLowerCase().contains(fragment);
          }
          if (!matchedAny)
            return false;
        }

        return true;
      }).toList();
    });
  }

  void _unfilterUsers() {
    setState(() {
      usersFiltered = usersVisible.toList();
      _ctrlUserFilter.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var textfield = TextField(
      autofocus: true,
      maxLines: 1,
      focusNode: FocusNode(),
      controller: _ctrlUserFilter,
      onChanged: _filterUsers,
      //onSubmitted: _submitMember,
      decoration: InputDecoration(
        hintText: "Find user",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          onPressed: _unfilterUsers,
          icon: Icon(Icons.clear),
        ),
      ),
    );

    var list = AppListView<User>(
      items: usersFiltered,
      itemBuilder: (User user) {
        return InkWell(
          child: ListTile(
            title: Text("${user.firstname} ${user.lastname}"),
            subtitle: Text("${user.key}"),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _handleSelect(user),
            ),
          ),
        );
      },
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 500,
        width: 430,
        child: Column(
          children: [
            AppButton(text: "Close", onPressed: () => Navigator.pop(context)),
            textfield,
            list,
          ],
        ),
      ),
    );
  }
}

/*

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

SelectController _ctrlMemberSelect = SelectController();
SelectController _ctrlParticipantSelect = SelectController();
*/
