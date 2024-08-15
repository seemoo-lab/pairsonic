import 'package:pairsonic/features/profile/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'storage_interface.dart';

class SqlDB extends StorageInterface {
  late Database _db;
  final String _users = "users";

  SqlDB() {
    init();
  }

  setup() async {
    //String path = join(await getDatabasesPath(), 'data.db');

    _db = await openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE $_users(userId TEXT PRIMARY KEY, name TEXT, bio TEXT, verified INTEGER, iconId INTEGER)');
      },
      version: 1,
    );
  }

  @override
  Future<void> init() async {
    await setup();
  }

  @override
  Future<void> resetDatabase() async {
    await databaseFactory.deleteDatabase(_db.path);
    await setup();
  }

  @override
  Future<bool> deleteUser(User user) async {
    return await _db.delete(_users, where: 'userId = ?', whereArgs: [user.id]) > 0;
  }

  @override
  Future<User> getUser(String id) async {
    List<Map<String, Object?>> query = await _db.query(
      _users,
      where: 'userId = ?',
      whereArgs: [id],
    );
    if (query.first.isEmpty) throw StateError('StateError: No User with id: $id exists.');
    if (query.length > 1) throw StateError('StateError: More than one User with id: $id exists.');
    print(query.first);
    User user = User.fromMap(query.first);
    print(user);
    return user;
  }

  @override
  Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> maps = await _db.query(_users);
    List<User> users = [];
    for (Map<String, dynamic> map in maps) {
      users.add(User.fromMap(map));
    }
    return users;
  }

  @override
  Future<bool> insertUser(User user) async {
    return await _db.insert(_users, user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace) > 0;
  }

  @override
  Future<bool> updateUser(User user) async {
    return await _db.update(_users, user.toMap(), where: 'userId = ?', whereArgs: [user.id]) > 0;
  }
}
