import 'package:vet/main.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/services/api/update_info_service.dart';
import 'package:http/http.dart' as http;
import 'package:vet/utils/error_parser.dart';

class UpdateInfo implements UpdateInfoService {
  static final url = '$baseUrl/vetowner/update';

  @override
  Future<UpdateInfoResponse> updateProfile(UpdateProfileRequest request) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return UpdateInfoResponse(
          message: 'Profile updated successfully', status: true);
    } else {
      return UpdateInfoResponse(
          message: ErrorParser.parseErrorResponse(response.body),
          status: false);
    }
  }
}
