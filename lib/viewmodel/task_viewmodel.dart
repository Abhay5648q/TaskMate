import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskmate/model/task_model.dart';

class TaskViewmodel extends ChangeNotifier {
  late Box<Tasks> _taskBox;

  String? taskname;
  final datecont = TextEditingController();
  final timecont = TextEditingController();

  TaskViewmodel() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<Tasks>('tasks');
    notifyListeners();
  }

  bool get isValid =>
      taskname != null && datecont.text.isNotEmpty && timecont.text.isNotEmpty;

  List<Tasks> get taskList => _taskBox.values.toList();

  void setTaskName(String? value) {
    taskname = value;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    if (date == null) return;

    final now = DateTime.now();
    final onlyToday = DateTime(now.year, now.month, now.day);
    final diff = date.difference(onlyToday).inDays;

    if (diff == 0) {
      datecont.text = "Today";
    } else if (diff == 1) {
      datecont.text = "Tomorrow";
    } else {
      datecont.text = "${date.day}-${date.month}-${date.year}";
    }
    notifyListeners();
  }

  void setTime(TimeOfDay? time) {
    if (time == null) return;

    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    timecont.text = "$formattedHour:$minute$suffix";
    notifyListeners();
  }

  Future<void> addTask() async {
    if (!isValid) return;

    final newTask = Tasks(taskname!, datecont.text, timecont.text, '');
    await _taskBox.add(newTask);

    taskname = null;
    datecont.clear();
    timecont.clear();
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    if (index >= 0 && index < _taskBox.length) {
      await _taskBox.getAt(index)?.delete();
      notifyListeners();
    }
  }
}
