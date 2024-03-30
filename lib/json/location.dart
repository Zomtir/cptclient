class Location implements Comparable {
  final int id;
  final String key;
  final String name;
  final String description;

  Location(this.id, this.key, this.name, this.description);

  Location.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'description': description,
      };

  @override
  bool operator ==(other) => other is Location && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
