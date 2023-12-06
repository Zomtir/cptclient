library crypto;

class SelectionData<T>
  final Widget Function(T) builder;
  final List<T> available;
  final List<T> chosen;
  final Function(T) onAdd;
  final Function(T) onRemove;
  final List<T> Function(List<T>, String) filter;