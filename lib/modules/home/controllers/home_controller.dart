import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../categories/models/category_model.dart';

// Provider
final homeControllerProvider =
    AsyncNotifierProvider<HomeController, List<CategoryModel>>(
      HomeController.new,
    );

// Controller
class HomeController extends AsyncNotifier<List<CategoryModel>> {
  final _dio = Dio();

  @override
  FutureOr<List<CategoryModel>> build() async {
    return await fetchCategories();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('${Api.baseUrl}/categories');

      if (response.statusCode == 200) {
        // Dio secara otomatis melakukan decode JSON menjadi Map/List
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data kategori');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }
}
