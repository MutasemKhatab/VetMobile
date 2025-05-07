import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/providers/language_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/screens/profile/profile_list_tile.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/app_localizations.dart';
import 'package:vet/utils/theme_util.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final vetOwner = Provider.of<VetOwnerProvider>(context).vetOwner;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile')),
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
              child: Text(context.tr('no_data')),
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
                    backgroundImage: NetworkImage(
                        '$baseUrl/api/image/${vetOwner.profilePicUrl}'),
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
                    vetOwner.address ?? context.tr('no_address_provided'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vetOwner.phoneNumber ??
                        context.tr('no_phone_number_provided'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ProfileListTile(
                    icon: Icons.pets,
                    title: context.tr('my_vets'),
                    onTap: () {
                      Navigator.pushNamed(context, '/vets');
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.brightness_6_rounded,
                    title: context.tr('theme'),
                    onTap: () => showThemeDialoge(context),
                  ),
                  ProfileListTile(
                    icon: Icons.language,
                    title: context.tr('language'),
                    onTap: () {
                      showLanguageDialog(context);
                    },
                  ),
                  ProfileListTile(
                    icon: Icons.lock,
                    title: context.tr('change_password'),
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
                    title: context.tr('logout'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(context.tr('logout')),
                            content: Text(context.tr('logout_confirmation')),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(context.tr('cancel')),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.login);
                                  ServiceProvider.sharedPreferenceService
                                      .removeToken();
                                  Provider.of<VetOwnerProvider>(context,
                                          listen: false)
                                      .clearVetOwner();
                                  Provider.of<VetProvider>(context,
                                          listen: false)
                                      .clearVets();
                                  Provider.of<VaccineProvider>(context,
                                          listen: false)
                                      .clearVaccines();
                                },
                                child: Text(context.tr('logout')),
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

  void showLanguageDialog(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr('select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text(context.tr('english')),
                value: 'en',
                groupValue: languageProvider.currentLanguage,
                onChanged: (value) {
                  languageProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text(context.tr('arabic')),
                value: 'ar',
                groupValue: languageProvider.currentLanguage,
                onChanged: (value) {
                  languageProvider.setLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
