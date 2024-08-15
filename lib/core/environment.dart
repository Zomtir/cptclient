enum Env {
  serverScheme,
  serverHost,
  serverPort,
  clientScheme,
  clientHost,
  clientPort;

  String? fromString() {
    switch (this) {
      case Env.serverScheme:
        return const bool.hasEnvironment('SERVER_SCHEME')
            ? const String.fromEnvironment('SERVER_SCHEME')
            : null;
      case Env.serverHost:
        return const bool.hasEnvironment('SERVER_HOST')
            ? const String.fromEnvironment('SERVER_HOST')
            : null;
      case Env.clientScheme:
        return const bool.hasEnvironment('CLIENT_SCHEME')
            ? const String.fromEnvironment('CLIENT_SCHEME')
            : null;
      case Env.clientHost:
        return const bool.hasEnvironment('CLIENT_HOST')
            ? const String.fromEnvironment('CLIENT_HOST')
            : null;
      default:
        throw '$this is not of type `String`';
    }
  }

  bool? fromBool() {
    switch (this) {
      default:
        throw '$this is not of type `bool`';
    }
  }

  int? fromInt() {
    switch (this) {
      case Env.serverPort:
        return const bool.hasEnvironment('SERVER_PORT')
            ? const int.fromEnvironment('SERVER_PORT')
            : null;
      case Env.clientPort:
        return const bool.hasEnvironment('CLIENT_PORT')
            ? const int.fromEnvironment('CLIENT_PORT')
            : null;
      default:
        throw '$this is not of type `int`';
    }
  }
}
