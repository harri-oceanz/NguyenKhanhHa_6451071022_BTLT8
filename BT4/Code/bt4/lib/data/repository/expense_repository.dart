import 'package:bt4/data/models/expense.dart';
import 'package:bt4/data/services/database_service.dart';

class ExpenseRepository {
  Future<int> insert(Expense e) async {
    final db = await DatabaseService.database;
    return db.insert('expenses', e.toMap());
  }

  Future<List<Expense>> getAll() async {
    final db = await DatabaseService.database;

    final result = await db.rawQuery('''
      SELECT expenses.*, categories.name as categoryName
      FROM expenses
      LEFT JOIN categories ON expenses.categoryId = categories.id
    ''');

    return result.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> update(Expense e) async {
    final db = await DatabaseService.database;
    return db.update(
      'expenses',
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.database;
    return db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> sumByCategory() async {
    final db = await DatabaseService.database;

    return await db.rawQuery('''
      SELECT categories.name, SUM(expenses.amount) as total
      FROM expenses
      JOIN categories ON expenses.categoryId = categories.id
      GROUP BY categories.name
    ''');
  }
}