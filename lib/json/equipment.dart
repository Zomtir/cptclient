import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/skill.dart';
import 'package:cptclient/json/user.dart';

class Equipment implements Comparable {
  int id;
  User user;
  Skill skill;
  Item item;
  int count;

  Equipment({
    required this.id,
    required this.user,
    required this.skill,
    required this.item,
    required this.count,
  });

  Equipment.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      user = User.fromJson(json['user']),
      skill = Skill.fromJson(json['skill']),
      item = Item.fromJson(json['item']),
      count = json['count'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'skill': skill.toJson(),
    'item': item.toJson(),
    'count': count,
  };

  @override
  bool operator ==(other) => other is Equipment && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int criteria1 = user.compareTo(other.term);
    if (criteria1 != 0) return criteria1;
    int criteria2 = skill.compareTo(other.skill);
    if (criteria2 != 0) return criteria2;
    int criteria3 = item.compareTo(other.item);
    return criteria3;
  }
}
