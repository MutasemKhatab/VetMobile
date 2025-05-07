import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/utils/app_localizations.dart';

class MyVets extends StatelessWidget {
  const MyVets({super.key});

  @override
  Widget build(BuildContext context) {
    final vets = Provider.of<VetProvider>(context).vets;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('my_vets')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addVet);
            },
          ),
        ],
      ),
      body: vets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'empty-pets-icon',
                    child: Icon(
                      Icons.pets,
                      size: 80,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_vets_added'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addVet);
                    },
                    icon: const Icon(Icons.add),
                    label: Text(context.tr('add_first_vet')),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: vets.length,
                itemBuilder: (context, index) {
                  final vet = vets[index];
                  return Material(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.vetScreen,
                          arguments: vet,
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image with hero animation
                          Hero(
                            tag: 'vet-image-${vet.id}',
                            child: vet.picUrl != null && vet.picUrl!.isNotEmpty
                                ? Image.network(
                                    "$baseUrl/api/image/${vet.picUrl!}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        child: Icon(
                                          Icons.pets,
                                          size: 64,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Icon(
                                      Icons.pets,
                                      size: 64,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                          ),

                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                  ],
                                  stops: const [0.6, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // Gender badge
                          Positioned(
                            top: 12,
                            right: 12,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    vet.gender.toLowerCase() == 'male'
                                        ? Icons.male_rounded
                                        : Icons.female_rounded,
                                    color: vet.gender.toLowerCase() == 'male'
                                        ? Colors.blueAccent
                                        : Colors.pinkAccent,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Vet info overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Hero(
                                    tag: 'vet-name-${vet.id}',
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        vet.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Hero(
                                        tag: 'vet-species-${vet.id}',
                                        child: Material(
                                          type: MaterialType.transparency,
                                          elevation: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.8),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              vet.species,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (vet.dateOfBirth != null) ...[
                                        const SizedBox(width: 6),
                                        Hero(
                                          tag: 'vet-age-${vet.id}',
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black26,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.cake,
                                                    color: Colors.white70,
                                                    size: 12,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    _calculateAge(
                                                        vet.dateOfBirth!),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
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
      return '$years yr${years > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months mo${months > 1 ? 's' : ''}';
    } else {
      return 'New';
    }
  }
}
