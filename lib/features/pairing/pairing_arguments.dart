import 'package:pairsonic/constants.dart';

class PairingArguments {
  late PairingMethod method;
  late Map<String, dynamic> args;

  PairingArguments({PairingMethod? method, Map<String, dynamic>? args}) {
    this.method = method ?? PairingMethodHelper.fromSettings();
    this.args = args?? {};
  }
}
