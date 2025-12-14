List<String> cleanSplit(String text) {
  List<String> extraList = text.replaceAll(RegExp(r'\s+'), ' ').split(',');
  extraList = extraList.map((e) => e.trim()).toList();
  extraList = extraList.where((e) => e.isNotEmpty).toList();
  return extraList;
}