import 'package:cptclient/material/fields/FieldInterface.dart';

class FieldController<T extends FieldInterface> {
  Future<List<T>> Function()? callItems;
  T? value;

  FieldController({this.callItems, this.value});
}
