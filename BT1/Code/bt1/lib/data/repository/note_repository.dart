import 'package:bt1/data/models/note.dart';
import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';

class NoteRepository {
  Future<int> insert(Note note) async {
    Database db = await DatabaseService.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAll() async {
    Database db = await DatabaseService.database;
    List<Map<String, dynamic>> result = await db.query('notes');
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> update(Note note) async {
    Database db = await DatabaseService.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await DatabaseService.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}