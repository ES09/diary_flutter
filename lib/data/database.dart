import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'diary.dart';

class DatabaseHelper {
  static final _databaseName = "diary.db";
  static final _databaseVersion = 1;
  static final diaryTable = "diary";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // 데이터 테이블 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $diaryTable (
        date INTEGER DEFAULT 0,
        title String,
        memo String,
        image String,
        status INTEGER DEFAULT 0
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  // insert, update diary
  Future<int> modifydiary(Diary diary) async {
    Database db = await instance.database;

    List<Diary> d = await getDiaryByDate(diary.date);

    if(d.isEmpty) {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status,
      };
      return await db.insert(diaryTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status,
      };
      return await db.update(diaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }
  }

  // all list
  Future <List<Diary>> getAllDiary() async {
    Database db = await instance.database;

    List<Diary> diarys = [];

    var queries = await db.query(diaryTable);
    print(queries);

    for (var q in queries) {
      diarys.add(Diary(
        title: q["title"],
        memo: q["memo"],
        image: q["image"],
        date: q["date"],
        status: q["status"]
      ));
    }

    return diarys;
  }

  // get list by date
  Future <List<Diary>> getDiaryByDate(int date) async {
    Database db = await instance.database;

    List<Diary> diarys = [];

    var queries = await db.query(diaryTable, where: "date = ?", whereArgs: [date]);
    for (var q in queries) {
      diarys.add(Diary(
        title: q["title"],
        memo: q["memo"],
        image: q["image"],
        date: q["date"],
        status: q["status"]
      ));
    }

    return diarys;
  }
}