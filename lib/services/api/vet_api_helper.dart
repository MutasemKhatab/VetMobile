// lib/services/api/vet_api_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/models/vet.dart';
import 'package:vet/services/auth/service_provider.dart';

class VetApiHelper {
  static final url = '$baseUrl/vet';

  static Future<List<Vet>> fetchVets() async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((vet) => Vet.fromJson(vet)).toList();
    } else {
      throw Exception('Failed to fetch vets');
    }
  }

  static Future<Vet> addVet(Vet vet) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(vet.toJson()),
    );
    if (response.statusCode == 201) {
      return Vet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add vet');
    }
  }

  static Future<bool> updateVet(Vet vet) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.put(
      Uri.parse('$url/${vet.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(vet.toJson()),
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to update vet ${response.body} ${vet.toJson()}');
    }
  }

  static Future<bool> deleteVet(int id) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete vet');
    }
  }
}
