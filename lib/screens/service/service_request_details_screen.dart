// lib/screens/service/service_request_details_screen.dart
import 'package:flutter/material.dart';
import 'package:vet/models/service_request.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/widgets/future_button.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceRequest serviceRequest;

  const ServiceRequestDetailsScreen({super.key, required this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    // Only show cancel button for non-completed and non-cancelled requests
    final bool canCancel = serviceRequest.status.toLowerCase() != 'completed' &&
        serviceRequest.status.toLowerCase() != 'cancelled';

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceRequest.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Service type and status card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Hero(
                      tag: 'service-icon-${serviceRequest.id}',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          serviceRequest.getServiceIcon(),
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceRequest.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Hero(
                            tag: 'service-status-${serviceRequest.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: serviceRequest
                                      .getStatusColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: serviceRequest.getStatusColor(),
                                  ),
                                ),
                                child: Text(
                                  serviceRequest.status,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: serviceRequest.getStatusColor(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      'Description',
                      serviceRequest.description,
                      Icons.description,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Request Date',
                      DateFormat('MMMM d, yyyy')
                          .format(serviceRequest.requestDate),
                      Icons.calendar_today,
                    ),
                    if (serviceRequest.status == 'Completed' &&
                        serviceRequest.completionDate != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        'Completion Date',
                        DateFormat('MMMM d, yyyy')
                            .format(serviceRequest.completionDate!),
                        Icons.check_circle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cancel button - only show if request status is not completed or cancelled
            if (canCancel)
              SizedBox(
                width: double.infinity,
                child: FutureButton(
                  onTap: () => _cancelServiceRequest(context),
                  title: 'Cancel Request',
                ),
              ),
          ])),
    );
  }

  // Show confirmation dialog before cancelling
  Future<bool> _showCancelConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Service Request'),
        content:
            const Text('Are you sure you want to cancel this service request?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Cancel the service request
  Future<void> _cancelServiceRequest(BuildContext context) async {
    final confirm = await _showCancelConfirmation(context);
    if (!confirm) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // Update the service request status to "Cancelled"
      final success =
          await Provider.of<ServiceRequestProvider>(context, listen: false)
              .updateServiceRequestStatus(serviceRequest.id, 'Cancelled');

      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('Service request cancelled successfully')),
        );
        // Go back to the previous screen
        navigator.pop();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to cancel service request')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildDetailRow(
      BuildContext context, String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
