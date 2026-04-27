import '../data/models/category.dart';
import '../data/repository/category_repository.dart';

class CategoryController {
  final repo = CategoryRepository();

  Future<List<Category>> getAll() => repo.getAll();

  Future<void> add(Category category) => repo.insert(category);
}