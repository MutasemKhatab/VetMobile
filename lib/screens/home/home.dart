import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/screens/home/emergency_button.dart';
import 'package:vet/screens/home/home_app_bar.dart';
import 'package:vet/screens/home/home_drawer.dart';
import 'package:vet/screens/home/home_grid_item.dart';
import 'package:vet/utils/app_localizations.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<VetOwnerProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    // Determine grid columns based on screen width
    final int columns = screenSize.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: const HomeAppBar(),
      bottomNavigationBar: const EmergencyButton(),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount:
              orientation == Orientation.landscape ? columns + 1 : columns,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          padding: const EdgeInsets.all(20.0),
          childAspectRatio: 1,
          children: [
            HomeGridItem(
              title: context.tr('profile'),
              icon: Icons.person,
              route: AppRoutes.profile,
            ),
            HomeGridItem(
              title: context.tr('service_truck'),
              icon: Icons.local_shipping,
              route: AppRoutes.serviceRequests,
              routeArgument: 'Truck',
            ),
            HomeGridItem(
              title: context.tr('service_field_hospital'),
              icon: Icons.local_hospital,
              route: AppRoutes.serviceRequests,
              routeArgument: 'Field Hospital',
            ),
            HomeGridItem(
              title: context.tr('service_quarantine_zone'),
              icon: Icons.coronavirus,
              route: AppRoutes.serviceRequests,
              routeArgument: 'Quarantine Zone',
            ),
            HomeGridItem(
              title: context.tr('service_surgery'),
              icon: Icons.medical_services,
              route: AppRoutes.serviceRequests,
              routeArgument: 'Surgery',
            ),
          ],
        );
      }),
      drawer: HomeDrawer(user: user.vetOwner),
    );
  }
}
