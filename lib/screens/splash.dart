import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/service_request_provider.dart';
import 'package:vet/providers/theme_provider.dart';
import 'package:vet/providers/vaccine_provider.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/services/auth/service_provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); //TODO changet the name and try using the FutureBuilder
    _initializeTheme();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final token = await ServiceProvider.tokenService.getToken();
      if (token != null) {
        await _getUserInfo();
        await _getVets();
        await _getVaccines4Vets();
        await _getServiceRequests();
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Future<void> _getUserInfo() async {
    await Provider.of<VetOwnerProvider>(context, listen: false).fetchVetOwner();
  }

  Future<void> _getVets() async {
    await Provider.of<VetProvider>(context, listen: false).fetchVets();
  }

  Future<void> _getVaccines4Vets() async {
    final vetProvider = Provider.of<VetProvider>(context, listen: false);
    for (var vet in vetProvider.vets) {
      await Provider.of<VaccineProvider>(context, listen: false)
          .fetchVaccinesForVet(vet.id);
    }
  }

  Future<void> _getServiceRequests() async {
    final vetOwnerProvider =
        Provider.of<VetOwnerProvider>(context, listen: false);
    if (vetOwnerProvider.vetOwner != null) {
      await Provider.of<ServiceRequestProvider>(context, listen: false)
          .fetchOwnerServiceRequests(vetOwnerProvider.vetOwner!.id);
    }
  }

  Future<void> _initializeTheme() async {
    await Provider.of<ThemeProvider>(context, listen: false)
        .loadThemeFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: () async {
        await _checkLoginStatus();
        await _initializeTheme();
        return true;
      }(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
