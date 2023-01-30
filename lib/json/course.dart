import 'branch.dart';

class Course implements Comparable {
  final int id;
  String key;
  String title;
  bool active;
  bool public;
  Branch? branch;
  int threshold;

  Course(this.id, this.key, this.title, this.active, this.public, this.branch, this.threshold);

  Course.fromVoid() :
    this.id = 0,
    this.key = "",
    this.title = "Course Title",
    this.active = true,
    this.public = true,
    this.branch = null,
    this.threshold = 0;

  Course.fromCourse(Course course) :
    this.id = 0,
    this.key = "",
    this.title = course.title,
    this.active = course.active,
    this.public = course.public,
    this.branch = course.branch,
    this.threshold = course.threshold;

  Course.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    key = json['key'],
    title = json['title'],
    active = json['active'],
    public = json['public'],
    branch = Branch.fromJson(json['branch']),
    threshold = json['threshold'];

  Map<String, dynamic> toJson() =>
  {
    'id': id,
    'key': key,
    'title': title,
    'active': active,
    'public': public,
    'branch': branch?.toJson(),
    'threshold': threshold,
  };

  bool operator == (other) => other is Course && id == other.id;
  int get hashCode => id.hashCode;

  @override
  int compareTo(other) {
    return this.title.compareTo(other.title);
  }
}
