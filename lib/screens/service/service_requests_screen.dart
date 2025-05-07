// lib/screens/service/service_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/routes.dart';
import 'package:intl/intl.dart';
import 'package:vet/widgets/future_button.dart';
import 'package:vet/utils/app_localizations.dart';

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key, required this.title});
  final String title;

  @override
  State<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadServiceRequests() async {
    final vetOwner =
        Provider.of<VetOwnerProvider>(context, listen: false).vetOwner;
    if (vetOwner != null) {
      await Provider.of<ServiceRequestProvider>(context, listen: false)
          .fetchOwnerServiceRequests(vetOwner.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('service_requests')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadServiceRequests,
        child: Consumer<ServiceRequestProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final serviceRequests = provider.serviceRequests(widget.title);
            if (serviceRequests.isEmpty || provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_none,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      context.tr('no_service_requests_found'),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey,
                              ),
                    ),
                    const SizedBox(height: 32),
                    FutureButton(
                      onTap: () async {
                        await Navigator.pushNamed(
                            context, AppRoutes.createServiceRequest);
                      },
                      title: context.tr('create_request'),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                ListView.builder(
                  itemCount: serviceRequests.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final request = serviceRequests[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              request.getStatusColor().withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.serviceRequestDetails,
                            arguments: request,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Hero(
                                    tag: 'service-icon-${request.id}',
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        request.getServiceIcon(),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      context.tr(request.title.toLowerCase()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  Hero(
                                    tag: 'service-status-${request.id}',
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: request
                                              .getStatusColor()
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: request.getStatusColor(),
                                          ),
                                        ),
                                        child: Text(
                                          request.status,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: request.getStatusColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                request.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${context.tr('request_date')}: ${DateFormat('MMM d, yyyy').format(request.requestDate)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.createServiceRequest);
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
