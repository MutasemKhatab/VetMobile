import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/models/vaccine.dart';
import 'package:vet/models/vet.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/services/permissions_service.dart';
import 'package:vet/widgets/future_button.dart';

class VetScreen extends StatelessWidget {
  final Vet vet;
  const VetScreen({super.key, required this.vet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVetDetails(context),
                _buildActionButtons(context),
                _buildVaccineSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: 'vet-name-${vet.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              vet.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
        centerTitle: false,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image with hero animation
            Hero(
              tag: 'vet-image-${vet.id}',
              child: vet.picUrl != null && vet.picUrl!.isNotEmpty
                  ? Image.network(
                      "$baseUrl/${vet.picUrl!}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.pets,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.pets,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
            ),

            // Gradient for better visibility of title
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Gender icon
            Positioned(
              top: 40,
              right: 16,
              child: Hero(
                tag: 'vet-gender-${vet.id}',
                child: Material(
                  type: MaterialType.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      vet.gender.toLowerCase() == 'male'
                          ? Icons.male_rounded
                          : Icons.female_rounded,
                      color: vet.gender.toLowerCase() == 'male'
                          ? Colors.blueAccent
                          : Colors.pinkAccent,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // Species tag
            Positioned(
              top: 100,
              right: 16,
              child: Hero(
                tag: 'vet-species-${vet.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      vet.species,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Age info if available
            if (vet.dateOfBirth != null)
              Positioned(
                top: 150,
                right: 16,
                child: Hero(
                  tag: 'vet-age-${vet.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cake_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            vet.dateOfBirth!.toLocal().toShortDateString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic info card
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Info grid
                  Row(
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.pets_rounded,
                        'Species',
                        vet.species,
                      ),
                      _buildInfoItem(
                        context,
                        vet.gender.toLowerCase() == 'male'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        'Gender',
                        vet.gender,
                        vet.gender.toLowerCase() == 'male'
                            ? Colors.blueAccent
                            : Colors.pinkAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.cake_rounded,
                        'Birthday',
                        vet.dateOfBirth != null
                            ? vet.dateOfBirth!.toLocal().toShortDateString()
                            : 'Not specified',
                      ),
                      if (vet.dateOfBirth != null)
                        _buildInfoItem(
                          context,
                          Icons.timeline_rounded,
                          'Age',
                          _calculateAge(vet.dateOfBirth!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String label, String value,
      [Color? iconColor]) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addVet, arguments: vet);
              },
              icon: Icon(Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 16),
              label: Text(
                'Edit',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FutureButton(
              onTap: () => _deleteVet(context),
              title: 'Delete',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVet(BuildContext context) async {
    final shouldDelete = await _showDeleteConfirmation(context);
    if (!shouldDelete) return;

    final result = await Provider.of<VetProvider>(context, listen: false)
        .deleteVet(vet.id);
    if (result) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete vet'),
        ),
      );
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this vet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Widget _buildVaccineSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.vaccines_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Vaccination Records',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Builder(
                builder: (context) {
                  final vaccines = Provider.of<VaccineProvider>(context)
                      .getVaccinesForVet(vet.id);

                  if (vaccines.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.vaccines_rounded,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No vaccines recorded',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vaccines.length,
                    itemBuilder: (context, index) {
                      final vaccine = vaccines[index];
                      final isLastDose = index == vaccines.length - 1;

                      return Container(
                        margin: EdgeInsets.only(bottom: isLastDose ? 0 : 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _showVaccineDetails(context, vaccine),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.vaccines_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vaccine.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          vaccine.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '${vaccine.doses.length} ${vaccine.doses.length == 1 ? 'dose' : 'doses'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVaccineDetails(BuildContext context, Vaccine vaccine) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.vaccines_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        vaccine.name,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vaccine.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Vaccination Schedule",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.separated(
                      separatorBuilder: (_, __) => Divider(height: 1),
                      shrinkWrap: true,
                      itemCount: vaccine.doses.length,
                      itemBuilder: (context, doseIndex) {
                        final doseDate = vaccine.doses[doseIndex];
                        final bool isPast = doseDate.isBefore(DateTime.now());

                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isPast
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${doseIndex + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isPast
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "Dose ${doseIndex + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (isPast) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            doseDate.toLocal().toShortDateString(),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.calendar_today_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => _addToCalendar(
                              context,
                              vaccine,
                              doseIndex,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FutureButton(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    title: "Close",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToCalendar(
      BuildContext context, dynamic vaccine, int doseIndex) async {
    // Check permissions first
    final hasPermission =
        await PermissionsService.requestCalendarPermissions(context);

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calendar permission is required to add events'),
        ),
      );
      return;
    }

    // Add to calendar
    final Event event = Event(
      allDay: true,
      title: 'Vaccine: ${vaccine.name}',
      description:
          'Reminder for ${vaccine.name} dose number ${doseIndex + 1} for ${vet.name}',
      startDate: vaccine.doses[doseIndex],
      endDate: vaccine.doses[doseIndex].add(const Duration(hours: 1)),
    );

    Add2Calendar.addEvent2Cal(event).then((result) {
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${vaccine.name} to calendar'),
          ),
        );
      }
    });
  }

  String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    int months = now.month - dateOfBirth.month;

    if (now.day < dateOfBirth.day) {
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    if (years > 0) {
      return years == 1 ? '1 year' : '$years years';
    } else if (months > 0) {
      return months == 1 ? '1 month' : '$months months';
    } else {
      final days = now.difference(dateOfBirth).inDays;
      return days == 1 ? '1 day' : '$days days';
    }
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
