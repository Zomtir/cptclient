library crypto;

import 'dart:math';

import 'package:crypto/crypto.dart';
import 'dart:convert';

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

String generateSaltHex() {
  Random random = Random.secure();
  // 128 bits, 16 * 8 bytes (u8), 32 characters, 2 hex chars per byte
  return List<String>.generate(16, (i) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}
