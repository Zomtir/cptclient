import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

class Possession implements Comparable {
  int id;
  Item item;
  User user;
  bool owned;
  Club? club;
  DateTime? transferDate;

  Possession(
      {required this.id,
      required this.item,
      required this.user,
      required this.owned,
      required this.club,
      required this.transferDate});

  Possession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        item = Item.fromJson(json['item']),
        user = User.fromJson(json['user']),
        owned = json['owned'],
        club = json['club'] == null ? null : Club.fromJson(json['club']),
        transferDate = parseNaiveDate(json['transfer_date']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'item': item.toJson(),
        'user': user.toJson(),
        'owned': owned,
        'club': club?.toJson(),
        'transfer_date': formatNaiveDate(transferDate),
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
