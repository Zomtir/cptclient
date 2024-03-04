// ignore_for_file: non_constant_identifier_names

class Skill implements Comparable {
  final int id;
  final String key;
  final String title;

  Skill(this.id, this.key, this.title);

  Skill.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'title': title,
  };

  @override
  bool operator == (other) => other is Skill && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return title.compareTo(other.description);
  }

}
