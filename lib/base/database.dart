// required package imports
import 'dart:async';
import 'package:mastodon/dao/relationship_dao.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/attachment_dao.dart';
import 'package:mastodon/dao/notification_dao.dart';
import 'package:mastodon/dao/setting_dao.dart';
import 'package:mastodon/dao/timeline_dao.dart';
import 'package:mastodon/helpers/datetime_converter.dart';
import 'package:mastodon_api/mastodon_api.dart';

import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/entries.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(
  version: 1,
  entities: [
    AccountEntity,
    StatusEntity,
    StatusHomeEntity,
    SettingEntity,
    AttachmentEntity,
    NotificationEntity,
    RelationshipEntity,
  ],
  views: [
    DatabaseInfo,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  StatusDao get statusDao;
  SettingDao get settingDao;
  AccountDao get accountDao;
  AttachmentDao get attachmentDao;
  TimelineDao get timelineDao;
  NotificationDao get notificationDao;
  RelationshipDao get relationshipDao;
}
