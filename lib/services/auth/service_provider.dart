import 'package:vet/services/api/vaccine_api_helper.dart';
import 'package:vet/services/api/vet_api_helper.dart';
import 'package:vet/services/api/vet_owner_api_helper.dart';
import 'package:vet/services/auth/change_password.dart';
import 'package:vet/services/auth/change_password_service.dart';
import 'package:vet/services/auth/login.dart';
import 'package:vet/services/auth/login_service.dart';
import 'package:vet/services/auth/register.dart';
import 'package:vet/services/auth/register_service.dart';
import 'package:vet/services/auth/token_service.dart';
import 'package:vet/services/api/update_info.dart';
import 'package:vet/services/api/update_info_service.dart';
import 'package:vet/services/storage/shared_preference_service.dart';

abstract class ServiceProvider {
  static LoginService get loginService => Login();
  static RegisterService get registerService => Register();
  static ChangePasswordService get changePasswordService => ChangePassword();
  static UpdateInfoService get updateInfoService => UpdateInfo();
  static TokenService get tokenService => TokenService();
  static SharedPreferenceService get sharedPreferenceService =>
      SharedPreferenceService();
  static VetOwnerApiHelper get vetOwnerApiHelper => VetOwnerApiHelper();
  static VetApiHelper get vetApiHelper => VetApiHelper();
  static VaccineApiHelper get vaccineApiHelper => VaccineApiHelper();
}
