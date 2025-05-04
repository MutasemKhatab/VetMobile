// lib/services/api/service_request_api_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vet/main.dart';
import 'package:vet/models/service_request.dart';
import 'package:vet/services/auth/service_provider.dart';

class ServiceRequestApiHelper {
  static final url = '$baseUrl/api/serviceRequest';

  static Future<List<ServiceRequest>> fetchOwnerServiceRequests(
      String ownerId) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.get(
      Uri.parse('$url/owner/$ownerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((request) => ServiceRequest.fromJson(request))
          .toList();
    } else {
      throw Exception('Failed to fetch owner service requests');
    }
  }

  static Future<ServiceRequest> addServiceRequest(
      ServiceRequest serviceRequest) async {
    final token = await ServiceProvider.tokenService.getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(serviceRequest.toJson()),
    );

    if (response.statusCode == 201) {
      return ServiceRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add service request');
    }
  }

  // Update an existing service request status
  static Future<bool> updateServiceRequestStatus(int id, String status) async {
    final statusUrl = '$url/status/$id';
    final token = await ServiceProvider.tokenService.getToken();

    final response = await http.put(
      Uri.parse(statusUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(status),
    );

    if (response.statusCode == 204) {
      // No Content response
      return true;
    } else {
      throw Exception(
          'Failed to update service request status: ${response.statusCode}');
    }
  }
}
