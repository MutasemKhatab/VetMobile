import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/services/storage/shared_preference_service.dart';

class TokenService {
  TokenService._privateConstructor();

  static final TokenService _instance = TokenService._privateConstructor();

  factory TokenService() {
    return _instance;
  }

  final SharedPreferenceService _sharedPreferenceService =
      ServiceProvider.sharedPreferenceService;
  String? _token;

  Future<void> saveToken(String token) async {
    _token = token;
    await _sharedPreferenceService.saveToken(token);
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    return await _sharedPreferenceService.getToken();
  }

  Future<void> removeToken() async {
    _token = null;
    await _sharedPreferenceService.removeToken();
  }


}
