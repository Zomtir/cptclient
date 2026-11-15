import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

class Possession implements Comparable {
  int id;
  Item item;
  User user;
  DateTime? acquisitionDate;
  bool owned;

  Possession({
    required this.id,
    required this.item,
    required this.user,
    required this.acquisitionDate,
    required this.owned,
  });

  Possession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        item = Item.fromJson(json['item']),
        user = User.fromJson(json['user']),
        acquisitionDate = parseIsoDate(json['acquisition_date']),
        owned = json['owned'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'item': item.toJson(),
        'user': user.toJson(),
        'acquisition_date': formatIsoDate(acquisitionDate),
        'owned': owned,
      };

  @override
  bool operator ==(other) => other is Possession && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int criteria1 = user.compareTo(other.user);
    if (criteria1 != 0) return criteria1;
    return item.compareTo(other.item);
  }
}
