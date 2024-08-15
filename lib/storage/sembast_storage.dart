import 'dart:io';

import 'package:pairsonic/features/profile/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'storage_interface.dart';

class SembastDB extends StorageInterface {
  Database? dbUsers;

  DatabaseFactory databaseFactory = databaseFactoryIo;

  var userStore = StoreRef<String, Map<String, Object?>>('users');

  SembastDB() {
    init();
  }

  initialize() async {
    Directory docDir;
    if (Platform.isIOS || Platform.isAndroid) {
      docDir = await getApplicationDocumentsDirectory();
    } else {
      docDir = Directory("database/sembastDB");
    }
    print(docDir.path);
    await docDir.create(recursive: true);

    String dbUsersPath = join(docDir.path, 'users.db');

    dbUsers = await databaseFactory.openDatabase(dbUsersPath);
  }

  @override
  Future<void> init() async {
    await initialize();
  }

  @override
  Future<void> resetDatabase() async {
    await Future.wait([
      userStore.delete(dbUsers!),
    ]);
  }

  @override
  Future<bool> deleteUser(User user) async {
    return await (userStore.record(user.id).delete(dbUsers!)) != null;
  }

  @override
  Future<User> getUser(String id) async {
    Map<String, Object?>? map = await userStore.record(id).get(dbUsers!);
    return User.fromMap(map!);
  }

  @override
  Future<List<User>> getUsers() async {
    final snapshots = await userStore.find(dbUsers!);
    return snapshots.map((snapshot) => User.fromMap(snapshot.value)).toList(growable: true);
  }

  @override
  Future<bool> insertUser(User user) async {
    await (userStore.record(user.id).put(dbUsers!, user.toMap()));
    return true;
  }

  @override
  Future<bool> updateUser(User user) async {
    return await insertUser(user);
  }
}
