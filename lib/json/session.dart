import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/slot.dart';
import 'package:cptclient/json/user.dart';

class Session {
  final String token;
  User? user;
  Slot? slot;
  Right? right;

  Session(this.token, {this.user, this.slot, this.right});
}

