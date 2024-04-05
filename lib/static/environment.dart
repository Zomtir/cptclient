enum Env {
  serverScheme,
  serverHost,
  serverPort;

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
      default:
        throw '$this is not of type `int`';
    }
  }
}
