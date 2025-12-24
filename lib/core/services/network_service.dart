import 'package:dio/dio.dart';
import 'secure_service.dart';
import 'api_service.dart';

class NetworkService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: Api.baseUrl));

  NetworkService._() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Tambahkan token ke header
          options.headers['Accept'] = 'application/json';
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Jika token expired (401)
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // ulang request dengan token baru
              final token = await SecureStorage.getToken();
              e.requestOptions.headers['Authorization'] = 'Bearer $token';
              final retryResponse = await _dio.fetch(
                e.requestOptions,
              ); // ulang request
              return handler.resolve(retryResponse);
            } else {
              // gagal refresh → hapus token
              await SecureStorage.deleteToken();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Dio get dio {
    NetworkService._();
    return _dio;
  }

  // fungsi refresh token
  static Future<bool> _refreshToken() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) return false;

      final response = await Dio().post(
        '${Api.baseUrl}/refresh',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await SecureStorage.saveToken(response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
