import 'package:cptclient/material/fields/FieldInterface.dart';
import 'package:cptclient/utils/result.dart';

class FieldController<T extends FieldInterface> {
  Future<Result<List<T>>> Function()? callItems;
  T? value;

  FieldController({this.callItems, this.value});
}
