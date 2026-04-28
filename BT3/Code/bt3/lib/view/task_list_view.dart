import 'package:bt3/controller/task_controller.dart';
import 'package:bt3/data/models/task.dart';
import 'package:bt3/data/services/file_service.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final controller = TaskController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await controller.getAll();
    setState(() => tasks = data);
  }

  void addTask() async {
    TextEditingController txt = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(controller: txt),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await controller.add(txt.text);
              Navigator.pop(context);
              load();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void exportJson() async {
    await FileService.export(tasks);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Exported!")));
  }

  void importJson() async {
    final data = await FileService.import();
    await controller.replaceAll(data);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo"),
        actions: [
          IconButton(onPressed: exportJson, icon: const Icon(Icons.upload)),
          IconButton(onPressed: importJson, icon: const Icon(Icons.download)),
        ],
      ),
      body: ListView(
        children: tasks.map((t) {
          return CheckboxListTile(
            title: Text(t.title),
            value: t.isDone,
            onChanged: (_) async {
              await controller.toggle(t);
              load();
            },
            secondary: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await controller.delete(t.id!);
                load();
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}