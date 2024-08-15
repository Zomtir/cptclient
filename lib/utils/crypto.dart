library crypto;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/* Am more secure / expensive client hashing method than sha256 is recommended
 * Examples:
 * https://pub.dev/packages/dbcrypt
 * https://pub.dev/packages/flutter_bcrypt
 */
String hashPassword(String password, String salt) {
  String saltedPassword = "$password|$salt";
  Digest hashedPassword = sha256.convert(utf8.encode(saltedPassword));
  return hashedPassword.toString();
}

Random _random = Random.secure();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

String assembleKey(List<int> structure) {
  List<String> segments = structure.map((size) => generateString(size)).toList();
  return segments.join("-");
}

String generateString(int length) {
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
  ));
}

String generateSaltHex() {
  // 128 bits, 16 * 8 bytes (u8), 32 characters, 2 hex chars per byte
  return List<String>.generate(16, (i) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}
