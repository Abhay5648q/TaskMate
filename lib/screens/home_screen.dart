import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taskmate/constants/colors.dart';
import 'package:taskmate/model/task_model.dart';
import 'package:taskmate/viewmodel/task_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      floatingActionButton: const FloatingButton(),
      appBar: AppBar(
        backgroundColor: secondary,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 14,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(Icons.task_alt_sharp, size: 20),
                ),
                SizedBox(width: 8),
                Text(
                  "TaskMate",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            CircleAvatar(
              foregroundImage: AssetImage(
                'assets/images/pexels-simon-robben-55958-614810.jpg',
              ),
              maxRadius: 16,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: Icon(Icons.task_alt_sharp, size: 20),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Tasks>('tasks').listenable(),
        builder: (context, Box<Tasks> box, _) {
          final tasks = box.values.toList();

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                "No tasks added yet.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Colors.green.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {
                        task.delete();
                      },
                    ),
                    title: Text(
                      task.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${task.date} at ${task.time}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        task.delete();
                      },
                    ),
                  ),
                  const Divider(color: Colors.black, height: 1, thickness: 0.5),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialog();
          },
        );
      },
      child: const Icon(Icons.add, size: 30, color: Colors.white),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.sizeOf(context).height;
    double sw = MediaQuery.sizeOf(context).width;
    final taskprovider = Provider.of<TaskViewmodel>(context, listen: false);
    return Dialog(
      shadowColor: Colors.lightGreenAccent,
      backgroundColor: const Color.fromARGB(255, 184, 223, 253),
      child: SizedBox(
        height: sh * 0.8,
        width: sw * 0.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.05,
            vertical: sh * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Create New Task",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "What has to be done",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: 'Enter New Task',
                onChanged: (value) {
                  taskprovider.setTaskName(value);
                },
              ),
              const SizedBox(height: 50),
              const Text(
                "Due Date",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                hint: 'Pick a Date',
                icon: Icons.calendar_month_outlined,
                readonly: true,
                controller: taskprovider.datecont,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2035),
                  );
                  taskprovider.setDate(date);
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                readonly: true,
                hint: 'Pick a Time',
                controller: taskprovider.timecont,
                icon: Icons.timer_rounded,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    barrierColor: background,
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  taskprovider.setTime(time);
                },
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 170, 239),
                  ),
                  onPressed: () {
                    taskprovider.addTask();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "ADD",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.onTap,
    this.readonly = false,
    this.onChanged,
    this.controller,
  });

  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readonly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        readOnly: readonly,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: icon != null
              ? InkWell(
                  onTap: onTap,
                  child: Icon(icon, color: Colors.black),
                )
              : null,
          focusedBorder: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
