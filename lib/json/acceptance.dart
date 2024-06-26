class Acceptance implements Comparable {
  final String _value;

  const Acceptance._init(this._value);

  static const List<Acceptance> values = [
    Acceptance._init('NULL'),
    Acceptance._init('DRAFT'),
    Acceptance._init('PENDING'),
    Acceptance._init('ACCEPTED'),
    Acceptance._init('REJECTED'),
  ];

  String get name => _value;

  static Acceptance get empty => const Acceptance._init('NULL');

  static Acceptance get draft => const Acceptance._init('DRAFT');

  static Acceptance get pending => const Acceptance._init('PENDING');

  static Acceptance get accepted => const Acceptance._init('ACCEPTED');

  static Acceptance get rejected => const Acceptance._init('REJECTED');

  static Acceptance? fromNullString(String? value) {
    if (value == null) return null;

    return values.firstWhere((confirmation) => confirmation._value == value.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid acceptance value'));
  }

  @override
  bool operator ==(other) => other is Acceptance && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}
