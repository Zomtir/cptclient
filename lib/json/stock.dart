import 'package:cptclient/json/club.dart';
import 'package:cptclient/json/item.dart';

class Stock implements Comparable {
  Club club;
  Item item;
  int owned;
  int loaned;

  Stock({required this.club, required this.item, required this.owned, required this.loaned});

  Stock.fromJson(Map<String, dynamic> json)
      : club = Club.fromJson(json['club']),
        item = Item.fromJson(json['item']),
        owned = json['owned'],
        loaned = json['loaned'];

  Map<String, dynamic> toJson() => {
        'club': club.toJson(),
        'item': item.toJson(),
        'owned': owned,
        'loaned': loaned,
      };

  @override
  bool operator ==(other) => other is Stock && club.id == other.club.id && item.id == other.item.id;

  @override
  int get hashCode => Object.hash(club.id, item.id);

  @override
  int compareTo(other) {
    int criteria1 = club.compareTo(other.club);
    if (criteria1 != 0) return criteria1;
    return item.compareTo(other.item);
  }
}
