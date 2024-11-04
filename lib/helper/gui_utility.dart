import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:pairsonic/storage/storage_interface.dart';

import 'gui_utility_interface.dart';

class GuiUtility implements GuiUtilityInterface {

  late StorageInterface storage = getIt<StorageInterface>();
  var settingsService = getIt<SettingsService>();

  @override
  Future<void> insertOrUpdateUser(User user, {allowSelf = false}) async {
    var identityService = getIt<IdentityService>();
    if (!allowSelf && user.id == identityService.self.id) return;

    var insertRes = await storage.insertUser(user);
    if (!insertRes) {
      await storage.updateUser(user);
    }
  }

  @override
  void resetDatabase() async {
    debugPrint("GuiUtility - resetDatabase: Resetting");
    storage.resetDatabase();
    await storage.init();
    createUser();
  }

  @override
  Future<void> addOrVerifyUser(PairingData pairingData) async {
    User? existingUser;
    try {
      existingUser = await storage.getUser(pairingData.deviceId);
    } on StateError catch (e) {
      debugPrint(e.message);
    }
    if (existingUser != null) {
      User newUserObj = User(id: existingUser.id,
          name: existingUser.name,
          bio: existingUser.bio,
          verified: true,
          iconId: existingUser.iconId);
      await storage.updateUser(newUserObj);
    } else {
      await storage.insertUser(User(id: pairingData.deviceId,
          name: pairingData.name,
          bio: pairingData.bio,
          verified: true,
          iconId: pairingData.iconId));
    }
  }

  @override
  Future<List<User>> getAllUser() async {
    List<User> users = await storage.getUsers();
    return users;
  }

  @override
  Future<User> getUserDetails(String userId) {
    return storage.getUser(userId);
  }

  @override
  Future init() {
    createUser();

    return this.storage.init();
  }

  void createUser() {
    debugPrint("GuiUtility - createUser: Insert self");
    var identityService = getIt<IdentityService>();
    insertOrUpdateUser(identityService.self, allowSelf: true);
  }

}