// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/models/models.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Account, Status])
abstract class AppDatabase extends FloorDatabase {
  StatusDao get statusDao;
}