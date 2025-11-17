import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
            CREATE TABLE contacts(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              firstName TEXT NOT NULL,
              lastName TEXT NOT NULL,
              email TEXT NOT NULL,
              phone TEXT NOT NULL,
              company TEXT,
              createdAt INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        company TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  // Méthodes pour Users
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return User.fromMap(result.first);
    return null;
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour Contacts
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final result = await db.query('contacts', orderBy: 'firstName ASC');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Contact?> getContactById(int id) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return Contact.fromMap(result.first);
    return null;
  }

  // NOUVELLE MÉTHODE : Recherche de contacts
  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'firstName LIKE ? OR lastName LIKE ? OR email LIKE ? OR phone LIKE ? OR company LIKE ?',
      whereArgs: List.filled(5, '%$query%'),
      orderBy: 'firstName ASC',
    );
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

