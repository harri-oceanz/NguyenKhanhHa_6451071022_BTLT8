import '../data/models/category.dart';
import '../data/repository/category_repository.dart';

class CategoryController {
  final repo = CategoryRepository();

  Future<List<Category>> getAll() async {
    return await repo.getAll();
  }

  Future<void> add(Category c) async {
    await repo.insert(c);
  }

  Future<void> delete(int id) async {
    await repo.delete(id);
  }
}