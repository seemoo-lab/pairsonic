import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pairsonic/features/setup/services/permission_service.dart';
import 'package:pairsonic/helper/ui/gui_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';
import 'features/profile/identity_service.dart';
import 'features/settings/settings_interface.dart';
import 'generated/l10n.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'service_locator.dart';
import 'storage/sembast_storage.dart';
import 'storage/sql_storage.dart';
import 'storage/storage_interface.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  var idService = getIt<IdentityService>();

  var deviceId = await idService.deviceId;
  debugPrint("Main: device ID is $deviceId");

  runApp(const PairSonicApp());
}

class PairSonicApp extends StatefulWidget {
  const PairSonicApp({super.key});

  @override
  State<PairSonicApp> createState() => _PairSonicAppState();

  static void setLanguage(BuildContext context, String language) async {
    _PairSonicAppState state =
    context.findAncestorStateOfType<_PairSonicAppState>()!;
    state.setLanguage(language);
  }
}

class _PairSonicAppState extends State<PairSonicApp> {
  final SettingsService _settingsService = getIt<SettingsService>();
  final IdentityService _identityService = getIt<IdentityService>();

  Locale _language = const Locale('en'); //Default language

  _PairSonicAppState() {
    _initDatabase(Database.sqlite);
  }

  ///Changes language of the app
  setLanguage(String language) {
    setState(() {
      if (_settingsService.getString("language") != null && S.delegate.supportedLocales.contains(Locale(_settingsService.getString("language")!))) {
        _language = Locale(_settingsService.getString("language")!);
      } else {
        _language = const Locale('en');
      }
      debugPrint("Language is set to ${_language.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Sets the language to en if not set in preferences
    if (_settingsService.getString("language") != null &&
        S.delegate.supportedLocales.contains(Locale(_settingsService.getString("language")!))) {
      _language = Locale(_settingsService.getString("language")!);
    } else {
      _settingsService.setString("language", 'en');
    }

    return FutureBuilder(
        future: _getInitialRoute(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final initialRoute = snapshot.data;
            return MaterialApp(
              title: 'PairSonic',
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: _language,
              onGenerateTitle: (BuildContext context) => 'PairSonic',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme(
                  brightness: Brightness.light,
                  primary: Color.fromRGBO(157, 132, 236, 1.0),
                  onPrimary: Color.fromRGBO(255, 255, 255, 1.0),
                  secondary: Color.fromRGBO(97, 91, 113, 1.0),
                  onSecondary: Color.fromRGBO(255, 255, 255, 1.0),
                  tertiary: Color.fromRGBO(210, 210, 210, 1.0),
                  onTertiary: Colors.black,
                  error: Color.fromRGBO(186, 26, 26, 1.0),
                  onError: Color.fromRGBO(255, 255, 255, 1.0),
                  surface: Color.fromRGBO(236, 230, 240, 1.0),
                  onSurface: Color.fromRGBO(30, 28, 19, 1.0),
                ),
                scaffoldBackgroundColor: GuiConstants.scaffoldBackgroundColorLight,
                appBarTheme: const AppBarTheme(
                  color: GuiConstants.scaffoldBackgroundColorLight,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme(
                  brightness: Brightness.dark,
                  primary: Color.fromRGBO(157, 132, 236, 1.0),
                  onPrimary: Color.fromRGBO(255, 255, 255, 1.0),
                  secondary: Color.fromRGBO(97, 91, 113, 1.0),
                  onSecondary: Color.fromRGBO(255, 255, 255, 1.0),
                  tertiary: Color.fromRGBO(99, 99, 99, 1.0),
                  onTertiary: Colors.white,
                  error: Color.fromRGBO(186, 26, 26, 1.0),
                  onError: Color.fromRGBO(255, 255, 255, 1.0),
                  surface: Color.fromRGBO(56, 53, 56, 1.0),
                  onSurface: Color.fromRGBO(239, 232, 232, 1.0),
                ),
                scaffoldBackgroundColor: GuiConstants.scaffoldBackgroundColorDark,
                appBarTheme: const AppBarTheme(
                  color: GuiConstants.scaffoldBackgroundColorDark,
                ),
              ),
              initialRoute: initialRoute,
              routes: AppRouter.routes,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<String> _getInitialRoute() async {
    if (await PermissionService.instance.checkPermissions().isGranted && _identityService.identitySet) {
      return AppRoutes.homePage;
    } else {
      return AppRoutes.welcome;
    }
  }

  void _initDatabase(Database database) async {
    StorageInterface databaseInterface;

    switch (database) {
      case Database.sembast:
        SembastDB sembastDB = SembastDB();
        databaseInterface = sembastDB;
        // _database = Database.sembast;
        break;
      case Database.sqlite:
        SqlDB sqlDB = SqlDB();
        databaseInterface = sqlDB;
        // _database = Database.sqlite;
        break;
    }

    GetIt.instance.registerSingleton<StorageInterface>(databaseInterface);
  }
}
