import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/screens/profile/profile_list_tile.dart';
import 'package:vet/utils/theme_util.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final vetOwner = Provider.of<VetOwnerProvider>(context).vetOwner;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.register,
                  arguments: vetOwner);
            },
          ),
        ],
      ),
      body: vetOwner == null
          ? Center(
              child: Text('No data'),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        NetworkImage('$baseUrl/${vetOwner.profilePicUrl}'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    vetOwner.fullName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  //email
                  Text(vetOwner.email,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Text(
                    vetOwner.address ?? 'No address provided',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vetOwner.phoneNumber ?? 'No phone number provided',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ProfileListTile(
                    icon: Icons.pets,
                    title: 'Manage Vets',
                    onTap: () {
                      Navigator.pushNamed(context, '/vets');
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.brightness_6_rounded,
                    title: 'Theme',
                    onTap: () => showThemeDialoge(context),
                  ),
                  ProfileListTile(
                    //TODO change the language
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {
                      //show dialog to select language
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Select Language'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  title: const Text('English'),
                                  value: 'en',
                                  groupValue:
                                      'en', // Replace with the current selected language
                                  onChanged: (value) {
                                    //change language to English
                                    Navigator.pop(context);
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Arabic'),
                                  value: 'ar',
                                  groupValue:
                                      'en', // Replace with the current selected language
                                  onChanged: (value) {
                                    //change language to Arabic
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.changePassword,
                      );
                    },
                  ),
                  //logout
                  ProfileListTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.login);
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
