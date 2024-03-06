
extension ListExtension on List {
  List<T> difference<T>(List<T> other) {
    return List<T>.from(toSet().difference(other.toSet()));
  }
}