import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

String version = "1.2.0";

String _serverScheme = 'https';
String _serverHost = 'localhost';
int _serverPort = 443;

RetryClient client = RetryClient(http.Client());

void configServer(String scheme, String host, int port) {
  _serverScheme = scheme;
  _serverHost = host;
  _serverPort = port;
}

Uri uri([String? path, Map<String, dynamic>? queryParameters]) {
  return Uri(
      scheme: _serverScheme,
      host: _serverHost,
      port: _serverPort,
      path: path,
      queryParameters: queryParameters);
}
