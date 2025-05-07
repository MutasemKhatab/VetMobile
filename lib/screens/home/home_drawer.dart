import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/main.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:vet/providers/language_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/utils/app_localizations.dart';
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
            title: Text(context.tr('change_theme')),
            onTap: () {
              showThemeDialoge(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(context.tr('change_language')),
            onTap: () {
              showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(context.tr('log_out')),
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
                          ServiceProvider.sharedPreferenceService.removeToken();
                          Provider.of<VetOwnerProvider>(context, listen: false)
                              .clearVetOwner();
                          Provider.of<VetProvider>(context, listen: false)
                              .clearVets();
                          Provider.of<VaccineProvider>(context, listen: false)
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
