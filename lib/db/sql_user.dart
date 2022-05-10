import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NewsUserDB {
  final String teamName;
  static Database? _db;

  NewsUserDB(this.teamName);
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();

      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    io.Directory docDirect = await getApplicationDocumentsDirectory();
    String path = join(docDirect.path, 'NewsUesr.db');
    var mydb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return mydb;
  }

  List category = [
    'Barcelona',
    'RealMadrid',
    'ManCity',
    'ManUnited',
    'Liga',
    'Saudiliga',
    'Ahli',
    'favorate',
    'Hella',
    'Shabab',
    'Nasr',
    'IthadSaudi',
    'milan',
    'Taavn',
    'Raad',
    'juventos',
    'FaisalySaudi',
    'Wehdah',
    'AtlitcoMadrid',
    'LaLiga',
    'Primire',
    'Liverpool',
    'Chelsea',
    'Arsenal',
    'Totenham',
    'ItalyLiga',
    'bunsliga',
    'Psg',
    'InterMilan',
    'UEFA',
    'Goals'
  ];
  _onCreate(Database db, int version) async {
    for (var item in category) {
      await db.execute(
        'CREATE TABLE "$item" ('
        'id INTEGER PRIMARY KEY,'
        'title TEXT,'
        'desc TEXT,'
        'link TEXT UNIQUE,'
        'content TEXT,'
        'imageurl TEXT,'
        'isread TEXT,'
        'pubdate TEXT,'
        'post_id TEXT,'
        'count TEXT,'
        'CommentDate TEXT,'
        'sitename TEXT'
        ')',
      );
      // print('$teamName Table Created');
    }
  }

  Future<int> create(Map<String, dynamic> data) async {
    initialDB();
    var dbClient = await db;

    var insert = dbClient!.insert(teamName, data);

    return insert;
  }

  Future<List> gitDistnct() async {
    var dbClinte = await db;
    var newsDistinct = await dbClinte!.rawQuery(
      // 'SELECT  title,imageurl,content,link,pubdate FROM $teamName ORDER BY pubdate DESC',
      'SELECT DISTINCT * FROM $teamName ORDER BY pubdate DESC',
    );
    return newsDistinct;
  }

  Future<int> deleteNote(String teamName, int id) async {
    var dbClient = await db;

    var deletednote =
        await dbClient!.rawDelete('DELETE FROM $teamName WHERE id =$id');

    return deletednote;
  }

  Future<int> update(String teamName, int id) async {
    var dbClient = await db;

    var updatecom = await dbClient!
        .rawUpdate('UPDATE $teamName set count=count+1 WHERE id =$id');

    return updatecom;
  }

  Future<int> deleteAllNews(String teamName) async {
    var dbClient = await db;

    var deletednote = await dbClient!.rawDelete('DELETE FROM $teamName ');

    return deletednote;
  }
}
