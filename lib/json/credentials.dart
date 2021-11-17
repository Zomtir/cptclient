class Credential {
  final String login;
  final String password;

  Credential(this.login, this.password);

  Credential.fromJson(Map<String, dynamic> json)
    : login = json['login'],
      password = json['password'];

  Map<String, dynamic> toJson() =>
    {
      'login': login,
      'password': password,
    };
}
