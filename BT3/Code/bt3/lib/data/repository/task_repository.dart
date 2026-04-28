import '../models/task.dart';
import '../services/database_service.dart';

class TaskRepository {
  Future<int> insert(Task task) async {
    final db = await DatabaseService.database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAll() async {
    final db = await DatabaseService.database;
    final data = await db.query('tasks');
    return data.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> update(Task task) async {
    final db = await DatabaseService.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await DatabaseService.database;
    await db.delete('tasks');
  }
}