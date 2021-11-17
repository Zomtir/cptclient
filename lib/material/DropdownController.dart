class DropdownController<T> {
  List<T> items;
  T? value;

  DropdownController({required this.items, this.value});
}
