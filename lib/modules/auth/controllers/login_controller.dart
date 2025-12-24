import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/secure_service.dart';

class LoginState {
  final bool loading;
  final String? error;

  const LoginState({this.loading = false, this.error});

  LoginState copyWith({bool? loading, String? error}) {
    return LoginState(loading: loading ?? this.loading, error: error);
  }
}

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(const LoginState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final dio = Dio(BaseOptions(baseUrl: Api.baseUrl));
      final response = await dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'];
        await SecureStorage.saveToken(token);

        state = state.copyWith(loading: false);
        return true;
      } else {
        state = state.copyWith(
          loading: false,
          error: "Login gagal, periksa email & password.",
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: "Terjadi kesalahan: $e");
    }
    return false;
  }
}

// Provider
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
      (ref) => LoginController(),
    );
