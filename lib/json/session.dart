import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/user.dart';

class UserSession {
  final String token;
  User? user;
  Right? right;

  UserSession(this.token, {this.user, this.right});
}

class EventSession {
  final String token;
  Event? event;

  EventSession(this.token, {this.event});
}