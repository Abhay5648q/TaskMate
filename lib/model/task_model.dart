import 'package:hive/hive.dart';
part 'task_model.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final String description;

  Tasks(this.name, this.date, this.time, this.description);
}