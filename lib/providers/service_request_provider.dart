// lib/providers/service_request_provider.dart
import 'package:flutter/material.dart';
import 'package:vet/models/service_request.dart';
import 'package:vet/services/api/service_request_api_helper.dart';

class ServiceRequestProvider with ChangeNotifier {
  List<ServiceRequest> _serviceRequests = [];
  bool _isLoading = false;
  String? _error;

  List<ServiceRequest> serviceRequests(String serviceType) => _serviceRequests
      .where((request) => request.title == serviceType)
      .toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOwnerServiceRequests(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final requests =
          await ServiceRequestApiHelper.fetchOwnerServiceRequests(ownerId);
      _serviceRequests = requests;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  // Add a new service request
  Future<bool> addServiceRequest(ServiceRequest serviceRequest) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newRequest =
          await ServiceRequestApiHelper.addServiceRequest(serviceRequest);
      _serviceRequests.add(newRequest);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update the status of an existing service request
  Future<bool> updateServiceRequestStatus(int id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success =
          await ServiceRequestApiHelper.updateServiceRequestStatus(id, status);

      if (success) {
        // Update the request in the local list
        final index = _serviceRequests.indexWhere((req) => req.id == id);
        if (index >= 0) {
          // Create a new service request with updated status
          final updatedRequest = ServiceRequest(
            id: _serviceRequests[index].id,
            title: _serviceRequests[index].title,
            description: _serviceRequests[index].description,
            requestDate: _serviceRequests[index].requestDate,
            status: status,
            completionDate: status == 'Completed' ? DateTime.now() : null,
            vetOwnerId: _serviceRequests[index].vetOwnerId,
          );
          _serviceRequests[index] = updatedRequest;
        }

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
