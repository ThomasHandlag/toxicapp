import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toxicapp/models/book_mark.dart';

class DBHanler {

static final DBHanler _instance = DBHanler._internal();

  factory DBHanler() => _instance;

  static Database? _database;

  DBHanler._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'app_db.ab'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE bookmark (id INTEGER PRIMARY KEY, identify TEXT)');
      },
      version: 1
    );
    return database;
  }

  Future<void> insert(Bookmark bookmark) async {
    final db = await database;
    await db.insert(
      'bookmark',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Bookmark bookmark) async {
    final db = await database;
    await db.delete(
      'bookmark',
      where: 'id = ?',
      whereArgs: [bookmark.id],
    );
  }
}