import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/features/profile/user_model.dart';
import 'package:pairsonic/service_locator.dart';

import 'storage_interface.dart';

class InMemoryStorage extends StorageInterface {

  IdentityService identityService = getIt<IdentityService>();

  Set<User> _users = <User>{};

  int testDelay = 0;

  @override
  Future<void> init() {
    // InMemory Storage is immediately ready
    return Future.delayed(Duration(seconds: testDelay), () => null);
  }

  @override
  Future<void> resetDatabase() async {
    var myId = await identityService.deviceId;
    User me = await getUser(myId);
    _users = <User>{};
    await insertUser(me);
    return Future.delayed(Duration(seconds: testDelay), () => null);
  }

  /// region User

  /// Get all [User]s
  @override
  Future<List<User>> getUsers() {
    return Future.delayed(Duration(seconds: testDelay), () => _users.toList());
  }

  /// Get a single [User]
  /// [id] the id of the [User]
  /// Raise [StateError] if no [User] with [id] exists
  /// Raise [StateError] if more than one [User] with [id] exists
  @override
  Future<User> getUser(String id) {
    var usersWithId = _users.where((element) => element.id == id);
    if (usersWithId.isEmpty) {
      throw StateError('User not found');
    } else if (usersWithId.length > 1) {
      throw StateError('User id is not unique');
    } else {
      return Future.delayed(Duration(seconds: testDelay), () => usersWithId.first);
    }
  }

  /// Insert a new [User]
  /// Return false if a [User] with the same id as [user] already exists
  /// Return true if [User] was successfully inserted
  @override
  Future<bool> insertUser(User user) {
    var usersWithId = _users.where((element) => element.id == user.id);
    if (usersWithId.isNotEmpty) {
      return Future.delayed(Duration(seconds: testDelay), () => false);
    }
    else {
      _users.add(user);
      return Future.delayed(Duration(seconds: testDelay), () => true);
    }
  }

  /// Update a [User]
  /// Overwrite all fields, identify [User] by id field of [user]
  /// Return false if [User] didn't exist
  /// Return true if [User] was successfully updated
  @override
  Future<bool> updateUser(User user) {
    var usersWithId = _users.where((element) => element.id == user.id);
    if (usersWithId.isEmpty) {
      return Future.delayed(Duration(seconds: testDelay), () => false);
    } else if (usersWithId.length > 1) {
      return Future.delayed(Duration(seconds: testDelay), () => false);
    } else {
      var u = usersWithId.first;
      _users.remove(u);
      _users.add(user);
      return Future.delayed(Duration(seconds: testDelay), () => true);
    }
  }

  /// Delete a [User]
  /// Identify [User] by id field of [user]
  /// Return true if [User] was successfully deleted
  @override
  Future<bool> deleteUser(User user) {
    var usersWithId = _users.where((element) => element.id == user.id);
    if (usersWithId.isEmpty) {
      return Future.delayed(Duration(seconds: testDelay), () => false);
    } else if (usersWithId.length > 1) {
      return Future.delayed(Duration(seconds: testDelay), () => false);
    } else {
     _users.removeWhere((element) => element.id == user.id);
     return Future.delayed(Duration(seconds: testDelay), () => true);
    }
  }

  /// endregion
}
