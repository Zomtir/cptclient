// ignore_for_file: non_constant_identifier_names

import 'branch.dart';

class Skill {
  Branch branch;
  int rank;
  int min = 0;
  int max = 0;

  Skill(this.branch, this.rank);

  Skill.threshold(Branch branch, int min, int max)
      : branch = branch,
        rank = 0,
        min = min,
        max = max;

  Skill.fromJson(List<dynamic> json)
      : branch = Branch.fromJson(json[0]),
        rank = json[1];
}
