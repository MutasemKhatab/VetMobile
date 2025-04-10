import 'package:flutter/material.dart';
import 'package:vet/models/service_request.dart';
import 'package:vet/models/vet.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:vet/screens/login/login.dart';
import 'package:vet/screens/password/change_password.dart';
import 'package:vet/screens/profile/profile.dart';
import 'package:vet/screens/register/register.dart';
import 'package:vet/screens/home/home.dart';
import 'package:vet/screens/service/create_service_request_screen.dart';
import 'package:vet/screens/service/service_request_details_screen.dart';
import 'package:vet/screens/service/service_requests_screen.dart';
import 'package:vet/screens/splash.dart';
import 'package:vet/screens/vet/add_vet.dart';
import 'package:vet/screens/vet/my_vets.dart';
import 'package:vet/screens/vet/vet_screen.dart';
import 'package:vet/screens/password/forgot_password.dart';
import 'package:vet/screens/password/verify_reset_code.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String splash = '/splash';
  static const String vets = '/vets';
  static const String vetScreen = '/vetScreen';
  static const String addVet = '/addVet';
  static const String changePassword = '/changePassword';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyResetCode = '/verifyResetCode';
  static const String serviceRequests = '/serviceRequests';
  static const String createServiceRequest = '/createServiceRequest';
  static const String serviceRequestDetails = '/serviceRequestDetails';
  static get initialRoute => splash;

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      register: (context) => Register(
            vetOwner: ModalRoute.of(context)!.settings.arguments as VetOwner?,
          ),
      login: (context) => const Login(),
      home: (context) => const Home(),
      profile: (context) => const Profile(),
      splash: (context) => const Splash(),
      vets: (context) => const MyVets(),
      changePassword: (context) => const ChangePassword(),
      addVet: (context) =>
          AddVet(vet: ModalRoute.of(context)!.settings.arguments as Vet?),
      vetScreen: (context) =>
          VetScreen(vet: ModalRoute.of(context)!.settings.arguments as Vet),
      forgotPassword: (context) => const ForgotPassword(),
      verifyResetCode: (context) => const VerifyResetCode(),
      serviceRequests: (context) => ServiceRequestsScreen(
            title: ModalRoute.of(context)!.settings.arguments as String,
          ),
      createServiceRequest: (context) => CreateServiceRequestScreen(),
      serviceRequestDetails: (context) => ServiceRequestDetailsScreen(
            serviceRequest:
                ModalRoute.of(context)!.settings.arguments as ServiceRequest,
          ),
    };
  }
}
