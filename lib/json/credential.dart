class Credential {
  final String login;
  final String password;
  final String salt;

  Credential(this.login, this.password, this.salt);

  @override
  Credential.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        password = json['password'],
        salt = json['salt'];

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'salt': salt,
      };
}
