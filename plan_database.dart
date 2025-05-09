import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planned_meal_model.dart';

class PlanDatabaseHelper {
  static final PlanDatabaseHelper instance = PlanDatabaseHelper._init();

  static Database? _database;

  PlanDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planned_meals.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plannedMeals (
        id TEXT PRIMARY KEY,
        name TEXT,
        thumbnail TEXT,
        day TEXT
      )
    ''');
  }

  Future<void> insertPlannedMeal(PlannedMeal meal) async {
    final db = await instance.database;
    await db.insert(
      'plannedMeals',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removePlannedMeal(String id) async {
    final db = await instance.database;
    await db.delete(
      'plannedMeals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PlannedMeal>> getMealsByDay(String day) async {
    final db = await instance.database;
    final maps = await db.query(
      'plannedMeals',
      where: 'day = ?',
      whereArgs: [day],
    );

    return maps.map((map) => PlannedMeal.fromMap(map)).toList();
  }

  Future<bool> isMealPlanned(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'plannedMeals',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<PlannedMeal>> getAllPlannedMeals() async {
    final db = await instance.database;
    final maps = await db.query('plannedMeals');
    return maps.map((map) => PlannedMeal.fromMap(map)).toList();
  }
  Future<bool> isDayBooked(String day) async {
    final db = await instance.database;
    final maps = await db.query(
      'plannedMeals',
      where: 'day = ?',
      whereArgs: [day],
    );
    return maps.isNotEmpty;
  }
}
