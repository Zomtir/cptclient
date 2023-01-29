// ignore_for_file: non_constant_identifier_names

class User implements Comparable {
  final int id;
  String key;
  bool? enabled;
  String firstname;
  String lastname;
  String? iban;
  String? email;
  String? phone;
  String? address;
  String? birthday;
  String? gender;
  int? organization_id;

  User(this.id, this.key, this.enabled, this.firstname, this.lastname);

  User.fromInfo(this.id, this.key, this.firstname, this.lastname) :
        this.enabled = false;

  User.fromVoid() :
    id = 0,
    key = "",
    firstname = "First Name",
    lastname = "Last Name";

  User.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    key = json['key'],
    enabled = json['enabled'],
    firstname = json['firstname'],
    lastname = json['lastname'],
    iban = json['iban'],
    email = json['email'],
    phone = json['phone'],
    address = json['address'],
    birthday = json['birthday'],
    gender = json['gender'],
    organization_id = json['organization_id'] != null ? int.tryParse(json['organization_id']) : null;

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'key': key,
      'enabled' : enabled,
      'firstname': firstname,
      'lastname': lastname,
      'iban': iban,
      'email': email,
      'phone': phone,
      'address': address,
      'birthday': birthday,
      'gender': gender,
      'organization_id': organization_id
    };

  bool operator == (other) => other is User && id == other.id;
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    int compLast = this.lastname.compareTo(other.lastname);

    if (compLast != 0)
      return compLast;

    int compFirst = this.firstname.compareTo(other.firstname);

    if (compFirst != 0)
      return compFirst;

    return this.key.compareTo(other.key);
  }

}

