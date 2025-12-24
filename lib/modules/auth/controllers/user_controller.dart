import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/services/network_service.dart';
import '../models/user_model.dart';

/// State untuk User
class UserState {
  final bool loading;
  final UserModel? user;
  final String? error;

  UserState({this.loading = false, this.user, this.error});

  UserState copyWith({bool? loading, UserModel? user, String? error}) {
    return UserState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// Controller User
class UserController extends StateNotifier<UserState> {
  UserController() : super(UserState());

  Future<void> getMyProfile() async {
    print("🔵 [UserController] Fetching /my-profile ...");
    state = state.copyWith(loading: true, error: null);

    try {
      final response = await NetworkService.dio.get('/my-profile');
      print("🟢 [UserController] Raw response: ${response.data}");

      if (response.statusCode == 200 && response.data['data'] != null) {
        final user = UserModel.fromJson(response.data['data']);
        print(
          "✅ [UserController] Parsed user -> "
          "id=${user.id}, name=${user.name}, email=${user.email}",
        );
        state = state.copyWith(user: user, loading: false);
      } else {
        print("⚠️ [UserController] Unexpected response: ${response.data}");
        state = state.copyWith(
          loading: false,
          error: 'Gagal mengambil data profil',
        );
      }
    } on DioException catch (e) {
      print("❌ [UserController] Dio error: ${e.response?.data}");
      state = state.copyWith(
        loading: false,
        error: e.response?.data['message'] ?? e.message,
      );
    } catch (e) {
      print("❌ [UserController] Unexpected error: $e");
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

/// Provider untuk UserController
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) {
    return UserController();
  },
);
