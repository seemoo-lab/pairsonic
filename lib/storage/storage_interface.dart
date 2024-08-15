import 'package:pairsonic/features/profile/user_model.dart';

/// Interface that all local storage solutions need to implement
abstract class StorageInterface {
  /// Initialize the storage
  Future<void> init();

  /// Reset the database
  Future<void> resetDatabase();

  /// Get all [User]s
  Future<List<User>> getUsers();

  /// Get a single [User]
  /// [id] the id of the [User]
  /// Raise [StateError] if no [User] with [id] exists
  /// Raise [StateError] if more than one [User] with [id] exists
  Future<User> getUser(String id);

  /// Update a [User]
  /// Overwrite all fields, identify [User] by id field of [user]
  /// Return false if [User] didn't exist
  /// Return true if [User] was successfully updated
  Future<bool> updateUser(User user);

  /// Delete a [User]
  /// Identify [User] by id field of [user]
  /// Return true if [User] was successfully deleted
  Future<bool> deleteUser(User user);

  /// Insert a new [User]
  /// Return false if a [User] with the same id as [user] already exists
  /// Return true if [User] was successfully inserted
  Future<bool> insertUser(User user);
}