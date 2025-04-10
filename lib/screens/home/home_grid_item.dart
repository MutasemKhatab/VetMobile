import 'package:flutter/material.dart';

class HomeGridItem extends StatelessWidget {
  const HomeGridItem({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
    this.routeArgument,
  });

  final String title;
  final IconData icon;
  final String route;
  final Object? routeArgument;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                route,
                arguments: routeArgument ?? title,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onTertiary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(125),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Icon(
                  icon,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
