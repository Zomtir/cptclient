
extension ListExtension on List {
  List<T> difference<T>(List<T> other) {
    return List<T>.from(toSet().difference(other.toSet()));
  }
}

int nullCompareTo<T extends Comparable<Object?>>(T? a, T? b, {bool revert = false}) {
  if (a == null && b == null) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  return a.compareTo(b) * (revert ? -1 : 1);
}

