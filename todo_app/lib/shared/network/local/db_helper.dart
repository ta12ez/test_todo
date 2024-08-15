import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
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
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY,
      todo TEXT,
      completed INTEGER,
      userId INTEGER
    )
    ''');
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> fetchTasks() async {
    final db = await database;
    final maps = await db.query('tasks');

    if (maps.isNotEmpty) {
      return maps.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }
}
