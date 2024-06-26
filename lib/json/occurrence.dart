class Occurrence implements Comparable {
  final String _value;

  const Occurrence._init(this._value);

  static const List<Occurrence> values = [
    Occurrence._init('NULL'),
    Occurrence._init('OCCURRING'),
    Occurrence._init('CANCELED'),
    Occurrence._init('VOIDED'),
  ];

  String get name => _value;

  static Occurrence get empty => const Occurrence._init('NULL');

  static Occurrence get occurring => const Occurrence._init('OCCURRING');

  static Occurrence get canceled => const Occurrence._init('CANCELED');

  static Occurrence get voided => const Occurrence._init('VOIDED');

  static Occurrence? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid occurrence value'));
  }

  @override
  bool operator ==(other) => other is Occurrence && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
