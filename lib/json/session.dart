import 'user.dart';
import 'slot.dart';
import 'right.dart';

class Session {
  final String token;
  User? user;
  Slot? slot;
  Right? right;

  Session(this.token, {this.user, this.slot, this.right});
}

