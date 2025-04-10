// lib/models/service_request.dart
import 'package:flutter/material.dart';

class ServiceRequest {
  final int id;
  final String title;
  final String description;
  final DateTime requestDate;
  final String status;
  final DateTime? completionDate;
  final String? vetOwnerId;

  ServiceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.requestDate,
    required this.status,
    this.completionDate,
    this.vetOwnerId,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      requestDate: DateTime.parse(json['requestDate']),
      status: json['status'],
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
      vetOwnerId: json['vetOwnerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
      'completionDate': completionDate?.toIso8601String(),
      'vetOwnerId': vetOwnerId,
    };
  }

  // Returns appropriate color based on status
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'inprogress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Returns appropriate icon based on service type
  IconData getServiceIcon() {
    switch (title.toLowerCase()) {
      case 'truck':
        return Icons.local_shipping;
      case 'field hospital':
        return Icons.local_hospital;
      case 'quarantine zone':
        return Icons.coronavirus;
      case 'surgery':
        return Icons.medical_services;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
