import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/capsule.dart';
import '../../models/content.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'time_capsule.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE capsules(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        groupName TEXT,
        members TEXT,
        createdAt TEXT NOT NULL,
        openDate TEXT NOT NULL,
        points INTEGER NOT NULL,
        isOpened INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE contents(
        id TEXT PRIMARY KEY,
        capsuleId TEXT NOT NULL,
        text TEXT NOT NULL,
        imageUrl TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (capsuleId) REFERENCES capsules (id)
      )
    ''');
  }

  Future<void> initDatabase() async {
    await database;
  }

  // Capsule CRUD operations
  Future<void> insertCapsule(Capsule capsule) async {
    final db = await database;
    await db.insert(
      'capsules',
      {
        'id': capsule.id,
        'title': capsule.title,
        'type': capsule.type.toString(),
        'groupName': capsule.groupName,
        'members': capsule.members.isNotEmpty ? capsule.members.join(',') : '',
        'createdAt': capsule.createdAt.toIso8601String(),
        'openDate': capsule.openDate.toIso8601String(),
        'points': capsule.points,
        'isOpened': capsule.isOpened ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Capsule>> getCapsules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('capsules');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Capsule(
        id: map['id'],
        title: map['title'],
        type: map['type'] == 'CapsuleType.personal'
            ? CapsuleType.personal
            : CapsuleType.group,
        groupName: map['groupName'],
        members: map['members'] != null && (map['members'] as String).isNotEmpty
            ? (map['members'] as String).split(',')
            : [],
        createdAt: DateTime.parse(map['createdAt']),
        openDate: DateTime.parse(map['openDate']),
        points: map['points'],
        isOpened: map['isOpened'] == 1,
      );
    });
  }

  Future<Capsule?> getCapsuleById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'capsules',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return Capsule(
      id: map['id'],
      title: map['title'],
      type: map['type'] == 'CapsuleType.personal'
          ? CapsuleType.personal
          : CapsuleType.group,
      groupName: map['groupName'],
      members: map['members'] != null && (map['members'] as String).isNotEmpty
          ? (map['members'] as String).split(',')
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      openDate: DateTime.parse(map['openDate']),
      points: map['points'],
      isOpened: map['isOpened'] == 1,
    );
  }

  Future<void> updateCapsule(Capsule capsule) async {
    final db = await database;
    await db.update(
      'capsules',
      {
        'title': capsule.title,
        'type': capsule.type.toString(),
        'groupName': capsule.groupName,
        'members': capsule.members.isNotEmpty ? capsule.members.join(',') : '',
        'openDate': capsule.openDate.toIso8601String(),
        'points': capsule.points,
        'isOpened': capsule.isOpened ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [capsule.id],
    );
  }

  Future<void> deleteCapsule(String id) async {
    final db = await database;
    await db.delete(
      'capsules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Content CRUD operations
  Future<void> insertContent(Content content) async {
    final db = await database;
    await db.insert(
      'contents',
      {
        'id': content.id,
        'capsuleId': content.capsuleId,
        'text': content.text,
        'imageUrl': content.imageUrl,
        'createdAt': content.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Content>> getContentsByCapsuleId(String capsuleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'capsuleId = ?',
      whereArgs: [capsuleId],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Content(
        id: map['id'],
        capsuleId: map['capsuleId'],
        text: map['text'],
        imageUrl: map['imageUrl'],
        createdAt: DateTime.parse(map['createdAt']),
      );
    });
  }

  Future<void> deleteContent(String id) async {
    final db = await database;
    await db.delete(
      'contents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 