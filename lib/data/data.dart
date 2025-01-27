import 'package:hive_flutter/hive_flutter.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  int id = -1;

  @HiveField(0)
  String name = "";

  @HiveField(1)
  bool isCompleted = false;

  @HiveField(2)
  Periority periority = Periority.low;
}

@HiveType(typeId: 1)
enum Periority {
  @HiveField(0)
  low,

  @HiveField(1)
  normal,

  @HiveField(2)
  high
}
