import 'package:path/path.dart';
import 'package:review_app/models/tasks.dart';
import 'package:sqflite/sqflite.dart';

const String fileName = "tasks_database.db";

class AppDatabase{
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;

  }

  Future _createDB(Database db, int version) async{

    await db.execute('''
  CREATE TABLE $tableName (
    $idField $idType,
    $titleField $textType,
    $descriptionField $textTypeNullable,
    $dueDateField $textType,
    $taskTypeField $textType,
    $isDoneField $boolType
    )
    ''');

  }

  Future<Database> _initializeDB(String fileName) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Task> createTask(Task task) async{
    final db = await instance.database;
    final id = await db.insert(tableName, task.toJson());
    return task.copyWith(id: id);
  }

  Future<List<Task?>> readAllTasks() async{
    final db = await instance.database;
    final result = await db.query(tableName, orderBy: "$dueDateField DESC");
    return result.map((json) => Task.fromJson(json)).toList();

  }

  Future<void> close() async{
    final db = await instance.database;
    return db.close();
  }


}


