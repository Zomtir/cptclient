class Location implements Comparable {
  final int id;
  final String key;
  final String title;

  Location(this.id, this.key, this.title);

  Location.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      key = json['key'],
      title = json['title'];

  Map<String, dynamic> toJson() => {
      'id': id,
      'key': key,
      'title': title,
    };

  @override
  bool operator == (other) => other is Location && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return title.compareTo(other.description);
  }
}
