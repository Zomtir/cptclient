import 'user.dart';
import 'slot.dart';

class Session {
  final String token;
  User? user;
  Slot? slot;

  Session(this.token, {this.user, this.slot});
}

