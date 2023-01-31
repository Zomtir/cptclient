import 'package:flutter/material.dart';

import 'package:cptclient/json/user.dart';

class UserFilter extends StatelessWidget {
  final List<User> users;
  final TextEditingController controller;
  final Function(List<User> users) onChange;

  const UserFilter({
    Key? key,
    required this.users,
    required this.controller,
    required this.onChange,
  }) : super(key: key);


  void _filterUsers(String filter) {
      List<User> filtered = users.where((User user) {
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

      onChange(filtered);
  }

  void _unfilterUsers() {
    onChange(users);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      maxLines: 1,
      focusNode: FocusNode(),
      controller: controller,
      onChanged: _filterUsers,
      decoration: InputDecoration(
        hintText: "Find user",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          onPressed: _unfilterUsers,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

}