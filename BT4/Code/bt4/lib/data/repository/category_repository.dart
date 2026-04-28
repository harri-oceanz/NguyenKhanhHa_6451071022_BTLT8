import 'package:sqflite/sqflite.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Future<int> insert(Category c) async {
    final db = await DatabaseService.database;
    return db.insert('categories', c.toMap());
  }

  Future<List<Category>> getAll() async {
    final db = await DatabaseService.database;
    final data = await db.query('categories');
    return data.map((e) => Category.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.database;
    return db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}