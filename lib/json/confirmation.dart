class Confirmation implements Comparable {
  final String _value;

  const Confirmation._init(this._value);

  static const List<Confirmation> values = [
    Confirmation._init('NULL'),
    Confirmation._init('POSITIVE'),
    Confirmation._init('NEUTRAL'),
    Confirmation._init('NEGATIVE')
  ];

  String get name => _value;

  static Confirmation get empty => const Confirmation._init('NULL');

  static Confirmation get positive => const Confirmation._init('POSITIVE');

  static Confirmation get neutral => const Confirmation._init('NEUTRAL');

  static Confirmation get negative => const Confirmation._init('NEGATIVE');

  static Confirmation? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid confirmation value'));
  }

  @override
  bool operator ==(other) => other is Confirmation && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
