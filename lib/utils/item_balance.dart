import 'package:cptclient/json/item.dart';
import 'package:cptclient/json/itemcat.dart';
import 'package:cptclient/json/user.dart';

typedef ItemBalance = (
  User user,
  Item item,
  int count_target,
  int count_current,
  int count_missing,
);

(int, int, Map<ItemCategory, (int, int)>) evalBalance(List<ItemBalance> totalBalance) {
  final uniqueUsers = <User>{};
  int miscItems = 0;
  final groupedItems = <ItemCategory, (int, int)>{};

  for (final balance in totalBalance) {
    final (user, item, countTarget, _, countMissing) = balance;

    uniqueUsers.add(user);

    if (item.category == null) {
      miscItems += 1;
      continue;
    }

    final old = groupedItems[item.category] ?? (0, 0);
    groupedItems[item.category!] = (
      old.$1 + countTarget,
      old.$2 + countMissing,
    );
  }

  return (uniqueUsers.length, miscItems, groupedItems);
}
