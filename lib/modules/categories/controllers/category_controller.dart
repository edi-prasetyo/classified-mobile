import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/category_model.dart';

// Provider untuk digunakan di berbagai halaman
final categoryControllerProvider =
    AsyncNotifierProvider<CategoryController, List<CategoryModel>>(
      CategoryController.new,
    );

class CategoryController extends AsyncNotifier<List<CategoryModel>> {
  final _dio = Dio();

  @override
  FutureOr<List<CategoryModel>> build() async {
    return await fetchCategories();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('${Api.baseUrl}/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat kategori');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }
}
