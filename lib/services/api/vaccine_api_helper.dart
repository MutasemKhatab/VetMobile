import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/models/vaccine.dart';
import 'package:vet/services/auth/service_provider.dart';

class VaccineApiHelper {
  static final url = '$baseUrl/api/vaccine';

  static Future<List<Vaccine>> fetchVaccines(int vetId) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.get(
      Uri.parse('$url/$vetId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((vaccine) => Vaccine.fromJson(vaccine)).toList();
    } else {
      throw Exception('Failed to fetch vaccines');
    }
  }
}
