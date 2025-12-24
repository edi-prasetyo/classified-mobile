import 'secure_service.dart';

class AuthService {
  // cek apakah ada token valid
  static Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    print("[AuthService] 🔑 Cek login. Token sekarang: $token");
    return token != null;
  }

  // logout user
  static Future<void> logout() async {
    print("[AuthService] 🚪 Logout. Token dihapus");
    await SecureStorage.deleteToken();
  }
}
