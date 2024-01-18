import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'theme_database.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE preference (
            id INTEGER PRIMARY KEY,
            theme TEXT
          )
        ''');

        for (int i = 1; i <= 10; i++) {
          await db.insert('preference', {'theme': ''});
        }
        await db.execute('''
          CREATE TABLE favorite (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bookId TEXT, 
            title TEXT,
            autor TEXT,
            imagenUrl TEXT,
            description TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          await db.execute('ALTER TABLE favorite ADD COLUMN title TEXT');
          await db.execute('ALTER TABLE favorite ADD COLUMN autor TEXT');
          await db.execute('ALTER TABLE favorite ADD COLUMN imagenUrl TEXT');
          await db.execute('ALTER TABLE favorite ADD COLUMN description TEXT');
        }
      },
    );
  }

  // Métodos para la tabla de PREFERENCE
  Future<List<Map<String, dynamic>>> getThemes() async {
    final db = await database;
    return await db.query('preference');
  }

  Future<List<Map<String, dynamic>>> getThemesNotNull() async {
    final db = await database;
    return await db.query('preference', where: "theme <> ''");
  }

  Future<int> countThemes() async {
    final db = await database;
    final result = await db.query('preference', where: "theme <> ''");
    final count = result.length;
    return count;
  }

  Future<void> updateTheme(int id, String newTheme) async {
    final db = await database;
    await db.update('preference', {'theme': newTheme},
        where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para la tabla de favoritos
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorite');
  }

  Future<void> addToFavorites(String bookId, String titulo, String autor,
      String imagenUrl, String description) async {
    final db = await database;
    await db.insert('favorite', {
      'bookId': bookId,
      'title': titulo,
      'autor': autor,
      'imagenUrl': imagenUrl,
      'description': description,
    });
  }

  Future<void> removeFromFavorites(String bookId) async {
    final db = await database;
    await db.delete('favorite', where: 'bookId = ?', whereArgs: [bookId]);
  }

  Future<bool> isFavorite(String bookId) async {
    final db = await database;
    final result =
        await db.query('favorite', where: 'bookId = ?', whereArgs: [bookId]);
    return result.isNotEmpty;
  }

  Future<void> removeAllFavorites() async {
    final db = await database;
    await db.delete('favorite');
  }
}
