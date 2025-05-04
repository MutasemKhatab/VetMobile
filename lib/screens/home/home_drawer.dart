import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/theme_util.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.user,
  });

  final VetOwner? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.firstName ?? ''),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                '$baseUrl/api/image/${user?.profilePicUrl}',
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Change Theme'),
            onTap: () {
              showThemeDialoge(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change Language'),
            onTap: () {
              // Implement language change logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);

              ServiceProvider.sharedPreferenceService.removeToken();
              Provider.of<VetOwnerProvider>(context, listen: false)
                  .clearVetOwner();
              Provider.of<VetProvider>(context, listen: false).clearVets();
              Provider.of<VaccineProvider>(context, listen: false)
                  .clearVaccines();
            },
          ),
        ],
      ),
    );
  }
}
