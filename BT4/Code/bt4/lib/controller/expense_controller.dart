import 'package:bt4/data/models/expense.dart';
import 'package:bt4/data/repository/expense_repository.dart';

class ExpenseController {
  final repo = ExpenseRepository();

  Future<List<Expense>> getAll() => repo.getAll();

  Future<void> add(Expense e) async {
    await repo.insert(e);
  }

  Future<void> update(Expense e) async {
    await repo.update(e);
  }

  Future<void> delete(int id) async {
    await repo.delete(id);
  }

  Future<List<Map<String, dynamic>>> getSummary() {
    return repo.sumByCategory();
  }
}