import 'package:sqflite/sqflite.dart';
import '../models/category.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Future<int> insert(Category category) async {
    final db = await DatabaseService.database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAll() async {
    final db = await DatabaseService.database;
    final data = await db.query('categories');
    return data.map((e) => Category.fromMap(e)).toList();
  }
}