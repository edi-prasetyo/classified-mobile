import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../explore/models/ad_model.dart';
import '../models/category_model.dart';

// Provider kategori (sudah ada)
final categoryControllerProvider =
    AsyncNotifierProvider<CategoryController, List<CategoryModel>>(
      CategoryController.new,
    );

// Provider ads by category (pakai controller yang sama)
final categoryAdsProvider = FutureProvider.family<List<AdModel>, String>((
  ref,
  slug,
) async {
  final controller = ref.read(categoryControllerProvider.notifier);
  return controller.fetchAdsByCategory(slug);
});

class CategoryController extends AsyncNotifier<List<CategoryModel>> {
  final _dio = Dio();

  @override
  FutureOr<List<CategoryModel>> build() async {
    return await fetchCategories();
  }

  /// =========================
  /// FETCH CATEGORIES
  /// =========================
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('${Api.baseUrl}/categories');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }
      throw Exception('Gagal memuat kategori');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    }
  }

  /// =========================
  /// FETCH ADS BY CATEGORY
  /// =========================
  Future<List<AdModel>> fetchAdsByCategory(String slug) async {
    try {
      final response = await _dio.get('${Api.baseUrl}/categories/$slug/ads');

      if (response.statusCode == 200) {
        final List data = response.data['data']['data']; // paginate
        return data.map((e) => AdModel.fromJson(e)).toList();
      }

      throw Exception('Gagal memuat iklan');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    }
  }
}
