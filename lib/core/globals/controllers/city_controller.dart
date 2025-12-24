import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/public_service.dart';
import '../models/city_model.dart';

final cityControllerProvider =
    StateNotifierProvider<CityController, AsyncValue<List<CityModel>>>(
      (ref) => CityController(),
    );

class CityController extends StateNotifier<AsyncValue<List<CityModel>>> {
  CityController() : super(const AsyncData([]));

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      final response = await PublicService.dio.get(
        '/cities',
        queryParameters: {"search": query},
      );

      final data = response.data['data'] as List;
      final cities = data.map((e) => CityModel.fromJson(e)).toList();

      state = AsyncData(cities);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
