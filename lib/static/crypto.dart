library crypto;

import 'package:crypto/crypto.dart';
import 'dart:convert';

/* Am more secure / expensive client hashing method than sha256 is recommended
 * Examples:
 * https://pub.dev/packages/dbcrypt
 * https://pub.dev/packages/flutter_bcrypt
 */
String hashPassword(String password, String salt) {
  String saltedPassword = "$password|CPT|$salt";
  Digest hashedPassword = sha256.convert(utf8.encode(saltedPassword));
  return hashedPassword.toString();
}