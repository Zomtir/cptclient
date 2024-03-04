class Club implements Comparable {
  final int id;
  final String name;
  final String description;

  Club(this.id, this.name, this.description);

  Club.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  @override
  bool operator == (other) => other is Club && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}

List<Club> filterClubs(List<Club> users, String filter) {
  List<Club> filtered = users.where((Club club) {
    Set<String> fragments = filter.toLowerCase().split(' ').toSet();
    List<String> searchspace = [club.name, club.description];

    for (var fragment in fragments) {
      bool matchedAny = false;
      for (var space in searchspace) {
        matchedAny = matchedAny || space.toLowerCase().contains(fragment);
      }
      if (!matchedAny) return false;
    }

    return true;
  }).toList();

  return filtered;
}