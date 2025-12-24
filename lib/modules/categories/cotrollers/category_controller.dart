import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/public_service.dart';
import '../models/category_model.dart';

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoryController(),
    );

class CategoryController
    extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoryController() : super(const AsyncLoading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await PublicService.dio.get('/categories');

      final data = response.data['data'] as List;

      // ambil children dari parent pertama
      final children = data.isNotEmpty ? data[0]['children'] as List : [];

      // log untuk debugging
      print('Parsed Children: $children');

      final categories = children
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      print('Categories List: $categories');

      state = AsyncData(categories);
    } catch (e, stack) {
      print('Error: $e');
      print('Stacktrace: $stack');
      state = AsyncError(e, stack);
    }
  }
}
