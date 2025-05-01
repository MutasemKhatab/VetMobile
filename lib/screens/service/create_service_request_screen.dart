// lib/screens/service/create_service_request_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/models/service_request.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/custom_input_field.dart';
import 'package:vet/widgets/future_button.dart';

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({super.key});

  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedService = 'Truck';

  final List<String> _serviceTypes = [
    'Truck',
    'Field Hospital',
    'Quarantine Zone',
    'Surgery',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final vetOwner =
        Provider.of<VetOwnerProvider>(context, listen: false).vetOwner;

    if (vetOwner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to create a service request')),
      );
      return;
    }

    final newRequest = ServiceRequest(
      id: 0,
      title: _selectedService,
      description: _descriptionController.text,
      requestDate: DateTime.now(),
      status: 'Pending',
      vetOwnerId: vetOwner.id,
    );

    final success =
        await Provider.of<ServiceRequestProvider>(context, listen: false)
            .addServiceRequest(newRequest);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service request created successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              Provider.of<ServiceRequestProvider>(context, listen: false)
                      .error ??
                  'Failed to create service request'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Service Request'),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Service Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _serviceTypes.length,
                itemBuilder: (context, index) {
                  final serviceType = _serviceTypes[index];
                  final isSelected = _selectedService == serviceType;

                  IconData iconData;
                  switch (serviceType.toLowerCase()) {
                    case 'truck':
                      iconData = Icons.local_shipping;
                      break;
                    case 'field hospital':
                      iconData = Icons.local_hospital;
                      break;
                    case 'quarantine zone':
                      iconData = Icons.coronavirus;
                      break;
                    case 'surgery':
                      iconData = Icons.medical_services;
                      break;
                    default:
                      iconData = Icons.miscellaneous_services;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedService = serviceType;
                      });
                    },
                    child: Hero(
                      tag: 'service-type-${serviceType}',
                      flightShuttleBuilder: (
                        BuildContext flightContext,
                        Animation<double> animation,
                        HeroFlightDirection flightDirection,
                        BuildContext fromHeroContext,
                        BuildContext toHeroContext,
                      ) {
                        return Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(iconData, size: 48),
                                  const SizedBox(height: 8),
                                  Text(serviceType),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              iconData,
                              size: 48,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              serviceType,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                  'Please add any additional details about your request like reason, location, contact info, etc.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              CustomInputField(
                labelText: 'Description',
                icon: Icons.description,
                controller: _descriptionController,
                validator: Validators.emptyText,
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FutureButton(
                  onTap: _submitForm,
                  title: 'Submit Request',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
