import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/ad_model.dart';
import '../../../core/services/api_service.dart';

final adControllerProvider = AsyncNotifierProvider<AdController, List<AdModel>>(
  AdController.new,
);

class AdController extends AsyncNotifier<List<AdModel>> {
  final _dio = Dio();

  @override
  FutureOr<List<AdModel>> build() async {
    return await fetchAds();
  }

  Future<List<AdModel>> fetchAds() async {
    try {
      final response = await _dio.get('${Api.baseUrl}/ads');
      if (response.statusCode == 200) {
        // Perhatikan path JSON: data -> data (pagination)
        final List<dynamic> listData = response.data['data']['data'];
        return listData.map((json) => AdModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Gagal memuat iklan: $e');
    }
  }

  static String formatCurrency(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }
}
