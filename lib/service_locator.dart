import 'package:get_it/get_it.dart';

import 'features/pairing/audio/services/wifi_p2p_service.dart';
import 'features/profile/identity_service.dart';
import 'features/settings/settings_interface.dart';
import 'features/settings/settings_service_shared_pref.dart';
import 'helper/gui_utility.dart';
import 'helper/gui_utility_interface.dart';
import 'storage/crypto_service.dart';

final getIt = GetIt.instance;

/// Function to serve the running instance of an interface or service.
///
/// {@category Services}
Future<void> setupGetIt() async {
  var prefSettings = SharedPrefSettingsService();
  await prefSettings.init();
  getIt.registerSingleton<SettingsService>(prefSettings);

  var cryptoService = await CryptoService.create();
  getIt.registerSingleton<CryptoService>(cryptoService);

  var identityService = await IdentityService.create();
  getIt.registerSingleton<IdentityService>(identityService);

  getIt.registerSingleton<GuiUtilityInterface>(GuiUtility());

  getIt.registerSingleton(WifiP2pService());
}
