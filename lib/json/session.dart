import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/user.dart';

class Session {
  final String token;
  User? user;
  Right? right;

  Session(this.token, {this.user, this.right});
}

