import 'dart:convert';

import 'package:vet/main.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:http/http.dart' as http;
import 'package:vet/services/auth/service_provider.dart';

class VetOwnerApiHelper {
  static final url = '$baseUrl/api/vetowner/current';

  Future<VetOwner> fetchVetOwner() async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return VetOwner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch vet owner');
    }
  }
}
