// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/enties/setting_model.dart';
import 'package:mastodon/helpers/datetime_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/entries.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [AccountEntity, StatusEntity, Setting])
abstract class AppDatabase extends FloorDatabase {
  StatusDao get statusDao;
  SettingDao get settingDao;
  AccountDao get accountDao;
}
