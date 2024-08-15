import 'package:flutter/cupertino.dart';
import 'package:pairsonic/features/contacts/ui/address_book_screen.dart';
import 'package:pairsonic/features/home/ui/home_page_screen.dart';
import 'package:pairsonic/features/pairing/pairing_screen.dart';
import 'package:pairsonic/features/profile/ui/profile_screen.dart';
import 'package:pairsonic/features/settings/ui/settings_screen.dart';
import 'package:pairsonic/features/setup/ui/permissions_screen.dart';
import 'package:pairsonic/features/setup/ui/profile_creation_screen.dart';
import 'package:pairsonic/features/setup/ui/welcome_screen.dart';
import 'package:pairsonic/router/app_routes.dart';

/// Helper to link named routes to screens
///
/// {@category Router}
class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.homePage: (BuildContext context) => const HomePageScreen(),
    AppRoutes.pairing: (BuildContext context) => const PairingScreen(),
    AppRoutes.contacts: (BuildContext context) => const AddressBookScreen(),
    AppRoutes.profile: (BuildContext context) => const ProfileScreen(),
    AppRoutes.profileCreation: (BuildContext context) => const ProfileCreationScreen(),
    AppRoutes.permissions: (BuildContext context) => const PermissionsScreen(),
    AppRoutes.welcome: (BuildContext context) => WelcomeScreen(),
    AppRoutes.settings: (BuildContext context) => const SettingsScreen(),
  };
}
