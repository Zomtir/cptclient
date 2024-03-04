// ignore_for_file: non_constant_identifier_names

import 'package:cptclient/json/branch.dart';

class Competence {
  Branch branch;
  int rank;
  int min;
  int max;

  Competence.threshold({required this.branch, this.rank = 0, this.min = 0, this.max = 0});

  Competence.fromJson(List<dynamic> json)
      : branch = Branch.fromJson(json[0]),
        rank = json[1],
        min = 0,
        max = 0;
}
