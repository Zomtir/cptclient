import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/material/widgets/AppTile.dart';
import 'package:cptclient/utils/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class Course extends FieldInterface implements Comparable {
  final int id;
  String key;
  String title;
  bool active;
  bool public;

  Course(this.id, this.key, this.title, this.active, this.public);

  Course.fromVoid()
      : id = 0,
        key = assembleKey([4, 2]),
        title = "Course Title",
        active = true,
        public = true;

  Course.fromCourse(Course course)
      : id = 0,
        key = assembleKey([4, 2]),
        title = course.title,
        active = course.active,
        public = course.public;

  Course.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'],
        active = json['active'],
        public = json['public'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'active': active,
        'public': public,
      };

  MapEntry<String, String> toEntry() => MapEntry(key, title);

  @override
  bool operator ==(other) => other is Course && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return removeDiacritics(title).compareTo(removeDiacritics(other.title));
  }

  @override
  get searchable => [title];

  @override
  Widget buildEntry(BuildContext context) {
    return Tooltip(
      message: "[$id] $key",
      child: Text("$title"),
    );
  }

  @override
  Widget buildTile(BuildContext context, {List<Widget>? trailing, VoidCallback? onTap}) {
    return AppTile(
      leading: Tooltip(message: "$key", child: Icon(Icons.info)),
      child: Text("$title"),
      onTap: onTap,
    );
  }

  @override
  Widget buildCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Tooltip(message: "$key", child: Icon(Icons.info)),
        title: Text("$title"),
      ),
    );
  }
}
