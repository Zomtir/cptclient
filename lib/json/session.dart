import 'package:cptclient/json/event.dart';
import 'package:cptclient/json/right.dart';
import 'package:cptclient/json/user.dart';
import 'package:cptclient/utils/format.dart';

class Session {
  final String key;
  final String token;
  final DateTime expiration;

  Session(this.key, this.token, this.expiration);

  Session.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        token = json['token'],
        expiration = parseIsoDateTime(json['expiration'])!.toLocal();

  Map<String, dynamic> toJson() => {
    'key' : key,
    'token': token,
    'expiration': formatIsoDateTime(expiration.toUtc()),
  };
}

class UserSession extends Session {
  User? user;
  Right? right;

  UserSession(super.key, super.token, super.expiration, {this.user, this.right});

  UserSession.fromJson(super.json) : super.fromJson();
}

class EventSession extends Session {
  Event? event;

  EventSession(super.key, super.token, super.expiration, {this.event});

  EventSession.fromJson(super.json) : super.fromJson();
}