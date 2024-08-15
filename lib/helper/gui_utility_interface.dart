
import 'package:pairsonic/features/profile/user_model.dart';

/// Abstract class to define a service to store local application data
/// {@category Interfaces}
abstract class GuiUtilityInterface {
  Future init();

  void resetDatabase();

  Future<void> insertOrUpdateUser(User user, {allowSelf = false});
  Future<void> addOrVerifyUser(PairingData pairingData);

  Future<List<User>> getAllUser();
  Future<User> getUserDetails(String userId);

  //Future<void> createTestData();
}
