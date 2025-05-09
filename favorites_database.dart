import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';

class FavoritesDatabaseHelper{
  static final FavoritesDatabaseHelper instance = FavoritesDatabaseHelper._internal();
  factory FavoritesDatabaseHelper() => instance;
  FavoritesDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            name TEXT,
            thumbnail TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(MealSummary meal) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': meal.id,
        'name': meal.name,
        'thumbnail': meal.thumbnail,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MealSummary>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');

    return maps.map((map) => MealSummary(
      id: map['id'] as String,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
    )).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}