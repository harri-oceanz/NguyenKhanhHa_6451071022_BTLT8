import 'package:bt3/data/models/task.dart';
import 'package:bt3/data/repository/task_repository.dart';

class TaskController {
  final repo = TaskRepository();

  Future<List<Task>> getAll() => repo.getAll();

  Future<void> add(String title) async {
    await repo.insert(Task(title: title));
  }

  Future<void> toggle(Task task) async {
    task.isDone = !task.isDone;
    await repo.update(task);
  }

  Future<void> delete(int id) async {
    await repo.delete(id);
  }

  Future<void> replaceAll(List<Task> tasks) async {
    await repo.deleteAll();
    for (var t in tasks) {
      await repo.insert(t);
    }
  }
}