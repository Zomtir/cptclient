// ignore_for_file: non_constant_identifier_names

class Access implements Comparable {
  final int id;
  final String key;
  final String title;

  Access(this.id, this.key, this.title);

  Access.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'title': title,
  };

  bool operator == (other) => other is Access && id == other.id;
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return this.title.compareTo(other.title);
  }

}
