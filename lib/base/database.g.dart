// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StatusDao? _statusDaoInstance;

  SettingDao? _settingDaoInstance;

  AccountDao? _accountDaoInstance;

  AttachmentDao? _attachmentDaoInstance;

  TimelineDao? _timelineDaoInstance;

  NotificationDao? _notificationDaoInstance;

  RelationshipDao? _relationshipDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `accounts` (`id` TEXT NOT NULL, `username` TEXT NOT NULL, `displayName` TEXT NOT NULL, `acct` TEXT NOT NULL, `note` TEXT NOT NULL, `url` TEXT NOT NULL, `avatar` TEXT NOT NULL, `avatarStatic` TEXT NOT NULL, `header` TEXT NOT NULL, `headerStatic` TEXT NOT NULL, `followersCount` INTEGER NOT NULL, `followingCount` INTEGER NOT NULL, `subscribingCount` INTEGER, `statusesCount` INTEGER NOT NULL, `isBot` INTEGER, `createdAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `statuses` (`id` TEXT NOT NULL, `url` TEXT, `uri` TEXT NOT NULL, `content` TEXT NOT NULL, `hasContent` INTEGER, `spoilerText` TEXT NOT NULL, `visibility` TEXT NOT NULL, `favouritesCount` INTEGER NOT NULL, `repliesCount` INTEGER NOT NULL, `reblogsCount` INTEGER NOT NULL, `language` TEXT, `inReplyToId` TEXT, `inReplyToAccountId` TEXT, `isFavourited` INTEGER, `isReblogged` INTEGER, `isMuted` INTEGER, `isBookmarked` INTEGER, `isSensitive` INTEGER, `isPinned` INTEGER, `createdAt` INTEGER NOT NULL, `reblogId` TEXT, `accountId` TEXT NOT NULL, FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `settings` (`name` TEXT NOT NULL, `value` TEXT NOT NULL, PRIMARY KEY (`name`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `attachments` (`id` TEXT NOT NULL, `statusId` TEXT NOT NULL, `type` INTEGER NOT NULL, `url` TEXT NOT NULL, `previewUrl` TEXT NOT NULL, `remoteUrl` TEXT, `description` TEXT, FOREIGN KEY (`statusId`) REFERENCES `statuses` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` TEXT NOT NULL, `type` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, `accountId` TEXT NOT NULL, `statusId` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `relationships` (`id` TEXT NOT NULL, `isFollowing` INTEGER NOT NULL, `isFollowed` INTEGER NOT NULL, `isBlocking` INTEGER NOT NULL, `isBlocked` INTEGER NOT NULL, `isMuting` INTEGER NOT NULL, `accountId` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `DATABASE_INFO` AS SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size();');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StatusDao get statusDao {
    return _statusDaoInstance ??= _$StatusDao(database, changeListener);
  }

  @override
  SettingDao get settingDao {
    return _settingDaoInstance ??= _$SettingDao(database, changeListener);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }

  @override
  AttachmentDao get attachmentDao {
    return _attachmentDaoInstance ??= _$AttachmentDao(database, changeListener);
  }

  @override
  TimelineDao get timelineDao {
    return _timelineDaoInstance ??= _$TimelineDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }

  @override
  RelationshipDao get relationshipDao {
    return _relationshipDaoInstance ??=
        _$RelationshipDao(database, changeListener);
  }
}

class _$StatusDao extends StatusDao {
  _$StatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statusEntityInsertionAdapter = InsertionAdapter(
            database,
            'statuses',
            (StatusEntity item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'uri': item.uri,
                  'content': item.content,
                  'hasContent': item.hasContent == null
                      ? null
                      : (item.hasContent! ? 1 : 0),
                  'spoilerText': item.spoilerText,
                  'visibility': item.visibility,
                  'favouritesCount': item.favouritesCount,
                  'repliesCount': item.repliesCount,
                  'reblogsCount': item.reblogsCount,
                  'language': item.language,
                  'inReplyToId': item.inReplyToId,
                  'inReplyToAccountId': item.inReplyToAccountId,
                  'isFavourited': item.isFavourited == null
                      ? null
                      : (item.isFavourited! ? 1 : 0),
                  'isReblogged': item.isReblogged == null
                      ? null
                      : (item.isReblogged! ? 1 : 0),
                  'isMuted':
                      item.isMuted == null ? null : (item.isMuted! ? 1 : 0),
                  'isBookmarked': item.isBookmarked == null
                      ? null
                      : (item.isBookmarked! ? 1 : 0),
                  'isSensitive': item.isSensitive == null
                      ? null
                      : (item.isSensitive! ? 1 : 0),
                  'isPinned':
                      item.isPinned == null ? null : (item.isPinned! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'reblogId': item.reblogId,
                  'accountId': item.accountId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StatusEntity> _statusEntityInsertionAdapter;

  @override
  Future<List<StatusEntity>> findAllStatuses() async {
    return _queryAdapter.queryList(
        'SELECT * FROM statuses   WHERE isReblogged IS false     AND (inReplyToAccountId = statuses.accountId OR inReplyToId IS NULL)     AND id NOT IN (       SELECT reblogId FROM statuses as reblogs WHERE reblogs.reblogId = statuses.id     )   ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String));
  }

  @override
  Future<StatusEntity?> findStatusById(String id) async {
    return _queryAdapter.query('SELECT * FROM statuses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<List<StatusEntity>> findStatusRepliesDescendants(String id) async {
    return _queryAdapter.queryList(
        'WITH RECURSIVE      descendants(id, inReplyToId) AS (       SELECT statuses.id, statuses.inReplyToId       FROM statuses        WHERE statuses.inReplyToId = ?1       UNION ALL              SELECT statuses.id, statuses.inReplyToId       FROM descendants       JOIN statuses ON descendants.id = statuses.inReplyToId     )     SELECT *     FROM statuses     WHERE id IN (       SELECT id        FROM descendants     )     ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => StatusEntity(id: row['id'] as String, url: row['url'] as String?, uri: row['uri'] as String, content: row['content'] as String, hasContent: row['hasContent'] == null ? null : (row['hasContent'] as int) != 0, spoilerText: row['spoilerText'] as String, visibility: row['visibility'] as String, favouritesCount: row['favouritesCount'] as int, repliesCount: row['repliesCount'] as int, reblogsCount: row['reblogsCount'] as int, language: row['language'] as String?, inReplyToId: row['inReplyToId'] as String?, inReplyToAccountId: row['inReplyToAccountId'] as String?, isFavourited: row['isFavourited'] == null ? null : (row['isFavourited'] as int) != 0, isReblogged: row['isReblogged'] == null ? null : (row['isReblogged'] as int) != 0, isMuted: row['isMuted'] == null ? null : (row['isMuted'] as int) != 0, isBookmarked: row['isBookmarked'] == null ? null : (row['isBookmarked'] as int) != 0, isSensitive: row['isSensitive'] == null ? null : (row['isSensitive'] as int) != 0, isPinned: row['isPinned'] == null ? null : (row['isPinned'] as int) != 0, reblogId: row['reblogId'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<List<StatusEntity>> findStatusRepliesAncestors(String id) async {
    return _queryAdapter.queryList(
        'WITH RECURSIVE      descendants(id, inReplyToId) AS (       SELECT statuses.id, statuses.inReplyToId       FROM statuses        WHERE statuses.id = ?1       UNION ALL              SELECT statuses.id, statuses.inReplyToId       FROM descendants       JOIN statuses ON descendants.inReplyToId = statuses.id     )     SELECT *     FROM statuses     WHERE id IN (       SELECT id        FROM descendants       WHERE id <> ?1     )     ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => StatusEntity(id: row['id'] as String, url: row['url'] as String?, uri: row['uri'] as String, content: row['content'] as String, hasContent: row['hasContent'] == null ? null : (row['hasContent'] as int) != 0, spoilerText: row['spoilerText'] as String, visibility: row['visibility'] as String, favouritesCount: row['favouritesCount'] as int, repliesCount: row['repliesCount'] as int, reblogsCount: row['reblogsCount'] as int, language: row['language'] as String?, inReplyToId: row['inReplyToId'] as String?, inReplyToAccountId: row['inReplyToAccountId'] as String?, isFavourited: row['isFavourited'] == null ? null : (row['isFavourited'] as int) != 0, isReblogged: row['isReblogged'] == null ? null : (row['isReblogged'] as int) != 0, isMuted: row['isMuted'] == null ? null : (row['isMuted'] as int) != 0, isBookmarked: row['isBookmarked'] == null ? null : (row['isBookmarked'] as int) != 0, isSensitive: row['isSensitive'] == null ? null : (row['isSensitive'] as int) != 0, isPinned: row['isPinned'] == null ? null : (row['isPinned'] as int) != 0, reblogId: row['reblogId'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<StatusEntity?> findStatusReplied(String id) async {
    return _queryAdapter.query('SELECT * FROM statuses WHERE inReplyTo = ?1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllStatuses() async {
    await _queryAdapter.queryNoReturn('DELETE FROM statuses');
  }

  @override
  Future<StatusEntity?> getOldestStatus() async {
    return _queryAdapter.query(
        'SELECT * FROM statuses   WHERE isReblogged IS false     AND (inReplyToAccountId = statuses.accountId OR inReplyToId IS NULL)     AND id NOT IN (       SELECT reblogId FROM statuses as reblogs WHERE reblogs.reblogId = statuses.id     )   ORDER BY createdAt ASC   LIMIT 1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String));
  }

  @override
  Future<void> insertStatus(StatusEntity status) async {
    await _statusEntityInsertionAdapter.insert(
        status, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertStatuses(List<StatusEntity> statuses) async {
    await _statusEntityInsertionAdapter.insertList(
        statuses, OnConflictStrategy.replace);
  }
}

class _$SettingDao extends SettingDao {
  _$SettingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _settingEntityInsertionAdapter = InsertionAdapter(
            database,
            'settings',
            (SettingEntity item) =>
                <String, Object?>{'name': item.name, 'value': item.value});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SettingEntity> _settingEntityInsertionAdapter;

  @override
  Future<List<SettingEntity>> findAllSettings() async {
    return _queryAdapter.queryList('SELECT * FROM settings',
        mapper: (Map<String, Object?> row) => SettingEntity(
            name: row['name'] as String, value: row['value'] as String));
  }

  @override
  Future<SettingEntity?> findSettingByName(String name) async {
    return _queryAdapter.query('SELECT * FROM settings WHERE name = ?1',
        mapper: (Map<String, Object?> row) => SettingEntity(
            name: row['name'] as String, value: row['value'] as String),
        arguments: [name]);
  }

  @override
  Future<void> removeSettingByName(String name) async {
    await _queryAdapter.queryNoReturn('DELETE FROM settings WHERE name = ?1',
        arguments: [name]);
  }

  @override
  Future<DatabaseInfo?> findDatabaseSize() async {
    return _queryAdapter.query('SELECT * FROM DATABASE_INFO',
        mapper: (Map<String, Object?> row) =>
            DatabaseInfo(size: row['size'] as int));
  }

  @override
  Future<void> deleteAllSettings() async {
    await _queryAdapter.queryNoReturn('DELETE FROM settings');
  }

  @override
  Future<void> vacuum() async {
    await _queryAdapter.queryNoReturn('vacuum');
  }

  @override
  Future<void> insertSetting(SettingEntity setting) async {
    await _settingEntityInsertionAdapter.insert(
        setting, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertSettings(List<SettingEntity> settings) async {
    await _settingEntityInsertionAdapter.insertList(
        settings, OnConflictStrategy.replace);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _accountEntityInsertionAdapter = InsertionAdapter(
            database,
            'accounts',
            (AccountEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'displayName': item.displayName,
                  'acct': item.acct,
                  'note': item.note,
                  'url': item.url,
                  'avatar': item.avatar,
                  'avatarStatic': item.avatarStatic,
                  'header': item.header,
                  'headerStatic': item.headerStatic,
                  'followersCount': item.followersCount,
                  'followingCount': item.followingCount,
                  'subscribingCount': item.subscribingCount,
                  'statusesCount': item.statusesCount,
                  'isBot': item.isBot == null ? null : (item.isBot! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener),
        _accountEntityDeletionAdapter = DeletionAdapter(
            database,
            'accounts',
            ['id'],
            (AccountEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'displayName': item.displayName,
                  'acct': item.acct,
                  'note': item.note,
                  'url': item.url,
                  'avatar': item.avatar,
                  'avatarStatic': item.avatarStatic,
                  'header': item.header,
                  'headerStatic': item.headerStatic,
                  'followersCount': item.followersCount,
                  'followingCount': item.followingCount,
                  'subscribingCount': item.subscribingCount,
                  'statusesCount': item.statusesCount,
                  'isBot': item.isBot == null ? null : (item.isBot! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccountEntity> _accountEntityInsertionAdapter;

  final DeletionAdapter<AccountEntity> _accountEntityDeletionAdapter;

  @override
  Future<List<AccountEntity>> findAllAccountes() async {
    return _queryAdapter.queryList('SELECT * FROM accounts',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)));
  }

  @override
  Future<AccountEntity?> findAccountById(String id) async {
    return _queryAdapter.query('SELECT * FROM accounts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        arguments: [id]);
  }

  @override
  Stream<AccountEntity?> findAccountByIdStream(String id) {
    return _queryAdapter.queryStream('SELECT * FROM accounts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        arguments: [id],
        queryableName: 'accounts',
        isView: false);
  }

  @override
  Future<AccountEntity?> findCurrentAccount() async {
    return _queryAdapter.query(
        'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)));
  }

  @override
  Stream<AccountEntity?> findCurrentAccountStream() {
    return _queryAdapter.queryStream(
        'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        queryableName: 'accounts',
        isView: false);
  }

  @override
  Future<void> deleteAllAccounts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM accounts');
  }

  @override
  Future<void> deleteAccountAttachments(String accountId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM attachments     WHERE attachments.statusId IN (       SELECT id FROM statuses WHERE accountId = ?1     )',
        arguments: [accountId]);
  }

  @override
  Future<void> deleteAccountStatuses(String accountId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM statuses WHERE accountId = ?1',
        arguments: [accountId]);
  }

  @override
  Future<void> insertAccount(AccountEntity account) async {
    await _accountEntityInsertionAdapter.insert(
        account, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAccounts(List<AccountEntity> accounts) async {
    await _accountEntityInsertionAdapter.insertList(
        accounts, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAccount(AccountEntity account) async {
    await _accountEntityDeletionAdapter.delete(account);
  }

  @override
  Future<void> deleteAccountWithRelations(String accountId) async {
    if (database is sqflite.Transaction) {
      await super.deleteAccountWithRelations(accountId);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.accountDao
            .deleteAccountWithRelations(accountId);
      });
    }
  }
}

class _$AttachmentDao extends AttachmentDao {
  _$AttachmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attachmentEntityInsertionAdapter = InsertionAdapter(
            database,
            'attachments',
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'statusId': item.statusId,
                  'type': item.type,
                  'url': item.url,
                  'previewUrl': item.previewUrl,
                  'remoteUrl': item.remoteUrl,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentEntity> _attachmentEntityInsertionAdapter;

  @override
  Future<AttachmentEntity?> findAttachmentById(String id) async {
    return _queryAdapter.query('SELECT * FROM attachments WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['statusId'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<AttachmentEntity>> findAttachemntsByStatus(
      String statusId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments WHERE statusId = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['statusId'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [statusId]);
  }

  @override
  Future<void> deleteAllAttachments() async {
    await _queryAdapter.queryNoReturn('DELETE FROM attachments');
  }

  @override
  Future<void> insertAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityInsertionAdapter.insert(
        attachment, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAttachments(List<AttachmentEntity> attachments) async {
    await _attachmentEntityInsertionAdapter.insertList(
        attachments, OnConflictStrategy.replace);
  }
}

class _$TimelineDao extends TimelineDao {
  _$TimelineDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _statusEntityInsertionAdapter = InsertionAdapter(
            database,
            'statuses',
            (StatusEntity item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'uri': item.uri,
                  'content': item.content,
                  'hasContent': item.hasContent == null
                      ? null
                      : (item.hasContent! ? 1 : 0),
                  'spoilerText': item.spoilerText,
                  'visibility': item.visibility,
                  'favouritesCount': item.favouritesCount,
                  'repliesCount': item.repliesCount,
                  'reblogsCount': item.reblogsCount,
                  'language': item.language,
                  'inReplyToId': item.inReplyToId,
                  'inReplyToAccountId': item.inReplyToAccountId,
                  'isFavourited': item.isFavourited == null
                      ? null
                      : (item.isFavourited! ? 1 : 0),
                  'isReblogged': item.isReblogged == null
                      ? null
                      : (item.isReblogged! ? 1 : 0),
                  'isMuted':
                      item.isMuted == null ? null : (item.isMuted! ? 1 : 0),
                  'isBookmarked': item.isBookmarked == null
                      ? null
                      : (item.isBookmarked! ? 1 : 0),
                  'isSensitive': item.isSensitive == null
                      ? null
                      : (item.isSensitive! ? 1 : 0),
                  'isPinned':
                      item.isPinned == null ? null : (item.isPinned! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'reblogId': item.reblogId,
                  'accountId': item.accountId
                }),
        _accountEntityInsertionAdapter = InsertionAdapter(
            database,
            'accounts',
            (AccountEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'displayName': item.displayName,
                  'acct': item.acct,
                  'note': item.note,
                  'url': item.url,
                  'avatar': item.avatar,
                  'avatarStatic': item.avatarStatic,
                  'header': item.header,
                  'headerStatic': item.headerStatic,
                  'followersCount': item.followersCount,
                  'followingCount': item.followingCount,
                  'subscribingCount': item.subscribingCount,
                  'statusesCount': item.statusesCount,
                  'isBot': item.isBot == null ? null : (item.isBot! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener),
        _attachmentEntityInsertionAdapter = InsertionAdapter(
            database,
            'attachments',
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'statusId': item.statusId,
                  'type': item.type,
                  'url': item.url,
                  'previewUrl': item.previewUrl,
                  'remoteUrl': item.remoteUrl,
                  'description': item.description
                }),
        _notificationEntityInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (NotificationEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'accountId': item.accountId,
                  'statusId': item.statusId
                }),
        _accountEntityDeletionAdapter = DeletionAdapter(
            database,
            'accounts',
            ['id'],
            (AccountEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'displayName': item.displayName,
                  'acct': item.acct,
                  'note': item.note,
                  'url': item.url,
                  'avatar': item.avatar,
                  'avatarStatic': item.avatarStatic,
                  'header': item.header,
                  'headerStatic': item.headerStatic,
                  'followersCount': item.followersCount,
                  'followingCount': item.followingCount,
                  'subscribingCount': item.subscribingCount,
                  'statusesCount': item.statusesCount,
                  'isBot': item.isBot == null ? null : (item.isBot! ? 1 : 0),
                  'createdAt': _dateTimeConverter.encode(item.createdAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StatusEntity> _statusEntityInsertionAdapter;

  final InsertionAdapter<AccountEntity> _accountEntityInsertionAdapter;

  final InsertionAdapter<AttachmentEntity> _attachmentEntityInsertionAdapter;

  final InsertionAdapter<NotificationEntity>
      _notificationEntityInsertionAdapter;

  final DeletionAdapter<AccountEntity> _accountEntityDeletionAdapter;

  @override
  Future<List<StatusEntity>> findAllStatuses() async {
    return _queryAdapter.queryList(
        'SELECT * FROM statuses   WHERE isReblogged IS false     AND (inReplyToAccountId = statuses.accountId OR inReplyToId IS NULL)     AND id NOT IN (       SELECT reblogId FROM statuses as reblogs WHERE reblogs.reblogId = statuses.id     )   ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String));
  }

  @override
  Future<StatusEntity?> findStatusById(String id) async {
    return _queryAdapter.query('SELECT * FROM statuses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<List<StatusEntity>> findStatusRepliesDescendants(String id) async {
    return _queryAdapter.queryList(
        'WITH RECURSIVE      descendants(id, inReplyToId) AS (       SELECT statuses.id, statuses.inReplyToId       FROM statuses        WHERE statuses.inReplyToId = ?1       UNION ALL              SELECT statuses.id, statuses.inReplyToId       FROM descendants       JOIN statuses ON descendants.id = statuses.inReplyToId     )     SELECT *     FROM statuses     WHERE id IN (       SELECT id        FROM descendants     )     ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => StatusEntity(id: row['id'] as String, url: row['url'] as String?, uri: row['uri'] as String, content: row['content'] as String, hasContent: row['hasContent'] == null ? null : (row['hasContent'] as int) != 0, spoilerText: row['spoilerText'] as String, visibility: row['visibility'] as String, favouritesCount: row['favouritesCount'] as int, repliesCount: row['repliesCount'] as int, reblogsCount: row['reblogsCount'] as int, language: row['language'] as String?, inReplyToId: row['inReplyToId'] as String?, inReplyToAccountId: row['inReplyToAccountId'] as String?, isFavourited: row['isFavourited'] == null ? null : (row['isFavourited'] as int) != 0, isReblogged: row['isReblogged'] == null ? null : (row['isReblogged'] as int) != 0, isMuted: row['isMuted'] == null ? null : (row['isMuted'] as int) != 0, isBookmarked: row['isBookmarked'] == null ? null : (row['isBookmarked'] as int) != 0, isSensitive: row['isSensitive'] == null ? null : (row['isSensitive'] as int) != 0, isPinned: row['isPinned'] == null ? null : (row['isPinned'] as int) != 0, reblogId: row['reblogId'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<List<StatusEntity>> findStatusRepliesAncestors(String id) async {
    return _queryAdapter.queryList(
        'WITH RECURSIVE      descendants(id, inReplyToId) AS (       SELECT statuses.id, statuses.inReplyToId       FROM statuses        WHERE statuses.id = ?1       UNION ALL              SELECT statuses.id, statuses.inReplyToId       FROM descendants       JOIN statuses ON descendants.inReplyToId = statuses.id     )     SELECT *     FROM statuses     WHERE id IN (       SELECT id        FROM descendants       WHERE id <> ?1     )     ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => StatusEntity(id: row['id'] as String, url: row['url'] as String?, uri: row['uri'] as String, content: row['content'] as String, hasContent: row['hasContent'] == null ? null : (row['hasContent'] as int) != 0, spoilerText: row['spoilerText'] as String, visibility: row['visibility'] as String, favouritesCount: row['favouritesCount'] as int, repliesCount: row['repliesCount'] as int, reblogsCount: row['reblogsCount'] as int, language: row['language'] as String?, inReplyToId: row['inReplyToId'] as String?, inReplyToAccountId: row['inReplyToAccountId'] as String?, isFavourited: row['isFavourited'] == null ? null : (row['isFavourited'] as int) != 0, isReblogged: row['isReblogged'] == null ? null : (row['isReblogged'] as int) != 0, isMuted: row['isMuted'] == null ? null : (row['isMuted'] as int) != 0, isBookmarked: row['isBookmarked'] == null ? null : (row['isBookmarked'] as int) != 0, isSensitive: row['isSensitive'] == null ? null : (row['isSensitive'] as int) != 0, isPinned: row['isPinned'] == null ? null : (row['isPinned'] as int) != 0, reblogId: row['reblogId'] as String?, createdAt: _dateTimeConverter.decode(row['createdAt'] as int), accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<StatusEntity?> findStatusReplied(String id) async {
    return _queryAdapter.query('SELECT * FROM statuses WHERE inReplyTo = ?1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllStatuses() async {
    await _queryAdapter.queryNoReturn('DELETE FROM statuses');
  }

  @override
  Future<StatusEntity?> getOldestStatus() async {
    return _queryAdapter.query(
        'SELECT * FROM statuses   WHERE isReblogged IS false     AND (inReplyToAccountId = statuses.accountId OR inReplyToId IS NULL)     AND id NOT IN (       SELECT reblogId FROM statuses as reblogs WHERE reblogs.reblogId = statuses.id     )   ORDER BY createdAt ASC   LIMIT 1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
            hasContent: row['hasContent'] == null
                ? null
                : (row['hasContent'] as int) != 0,
            spoilerText: row['spoilerText'] as String,
            visibility: row['visibility'] as String,
            favouritesCount: row['favouritesCount'] as int,
            repliesCount: row['repliesCount'] as int,
            reblogsCount: row['reblogsCount'] as int,
            language: row['language'] as String?,
            inReplyToId: row['inReplyToId'] as String?,
            inReplyToAccountId: row['inReplyToAccountId'] as String?,
            isFavourited: row['isFavourited'] == null
                ? null
                : (row['isFavourited'] as int) != 0,
            isReblogged: row['isReblogged'] == null
                ? null
                : (row['isReblogged'] as int) != 0,
            isMuted:
                row['isMuted'] == null ? null : (row['isMuted'] as int) != 0,
            isBookmarked: row['isBookmarked'] == null
                ? null
                : (row['isBookmarked'] as int) != 0,
            isSensitive: row['isSensitive'] == null
                ? null
                : (row['isSensitive'] as int) != 0,
            isPinned:
                row['isPinned'] == null ? null : (row['isPinned'] as int) != 0,
            reblogId: row['reblogId'] as String?,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String));
  }

  @override
  Future<List<AccountEntity>> findAllAccountes() async {
    return _queryAdapter.queryList('SELECT * FROM accounts',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)));
  }

  @override
  Future<AccountEntity?> findAccountById(String id) async {
    return _queryAdapter.query('SELECT * FROM accounts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        arguments: [id]);
  }

  @override
  Stream<AccountEntity?> findAccountByIdStream(String id) {
    return _queryAdapter.queryStream('SELECT * FROM accounts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        arguments: [id],
        queryableName: 'accounts',
        isView: false);
  }

  @override
  Future<AccountEntity?> findCurrentAccount() async {
    return _queryAdapter.query(
        'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)));
  }

  @override
  Stream<AccountEntity?> findCurrentAccountStream() {
    return _queryAdapter.queryStream(
        'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')',
        mapper: (Map<String, Object?> row) => AccountEntity(
            id: row['id'] as String,
            username: row['username'] as String,
            displayName: row['displayName'] as String,
            acct: row['acct'] as String,
            note: row['note'] as String,
            url: row['url'] as String,
            avatar: row['avatar'] as String,
            avatarStatic: row['avatarStatic'] as String,
            header: row['header'] as String,
            headerStatic: row['headerStatic'] as String,
            followersCount: row['followersCount'] as int,
            followingCount: row['followingCount'] as int,
            subscribingCount: row['subscribingCount'] as int?,
            statusesCount: row['statusesCount'] as int,
            isBot: row['isBot'] == null ? null : (row['isBot'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int)),
        queryableName: 'accounts',
        isView: false);
  }

  @override
  Future<void> deleteAllAccounts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM accounts');
  }

  @override
  Future<void> deleteAccountAttachments(String accountId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM attachments     WHERE attachments.statusId IN (       SELECT id FROM statuses WHERE accountId = ?1     )',
        arguments: [accountId]);
  }

  @override
  Future<void> deleteAccountStatuses(String accountId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM statuses WHERE accountId = ?1',
        arguments: [accountId]);
  }

  @override
  Future<AttachmentEntity?> findAttachmentById(String id) async {
    return _queryAdapter.query('SELECT * FROM attachments WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['statusId'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<AttachmentEntity>> findAttachemntsByStatus(
      String statusId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attachments WHERE statusId = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['statusId'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [statusId]);
  }

  @override
  Future<void> deleteAllAttachments() async {
    await _queryAdapter.queryNoReturn('DELETE FROM attachments');
  }

  @override
  Future<List<NotificationEntity>> findAllNotifications() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications     ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => NotificationEntity(
            id: row['id'] as String,
            type: row['type'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String,
            statusId: row['statusId'] as String?));
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications');
  }

  @override
  Future<void> insertStatus(StatusEntity status) async {
    await _statusEntityInsertionAdapter.insert(
        status, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertStatuses(List<StatusEntity> statuses) async {
    await _statusEntityInsertionAdapter.insertList(
        statuses, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAccount(AccountEntity account) async {
    await _accountEntityInsertionAdapter.insert(
        account, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAccounts(List<AccountEntity> accounts) async {
    await _accountEntityInsertionAdapter.insertList(
        accounts, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityInsertionAdapter.insert(
        attachment, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAttachments(List<AttachmentEntity> attachments) async {
    await _attachmentEntityInsertionAdapter.insertList(
        attachments, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertNotification(NotificationEntity notification) async {
    await _notificationEntityInsertionAdapter.insert(
        notification, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertNotifications(
      List<NotificationEntity> notifications) async {
    await _notificationEntityInsertionAdapter.insertList(
        notifications, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAccount(AccountEntity account) async {
    await _accountEntityDeletionAdapter.delete(account);
  }

  @override
  Future<void> saveTimelineStatuses(List<Status> statuses) async {
    if (database is sqflite.Transaction) {
      await super.saveTimelineStatuses(statuses);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.timelineDao.saveTimelineStatuses(statuses);
      });
    }
  }

  @override
  Future<void> deleteAccountWithRelations(String accountId) async {
    if (database is sqflite.Transaction) {
      await super.deleteAccountWithRelations(accountId);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.timelineDao
            .deleteAccountWithRelations(accountId);
      });
    }
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notificationEntityInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (NotificationEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'createdAt': _dateTimeConverter.encode(item.createdAt),
                  'accountId': item.accountId,
                  'statusId': item.statusId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationEntity>
      _notificationEntityInsertionAdapter;

  @override
  Future<List<NotificationEntity>> findAllNotifications() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notifications     ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => NotificationEntity(
            id: row['id'] as String,
            type: row['type'] as String,
            createdAt: _dateTimeConverter.decode(row['createdAt'] as int),
            accountId: row['accountId'] as String,
            statusId: row['statusId'] as String?));
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications');
  }

  @override
  Future<void> insertNotification(NotificationEntity notification) async {
    await _notificationEntityInsertionAdapter.insert(
        notification, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertNotifications(
      List<NotificationEntity> notifications) async {
    await _notificationEntityInsertionAdapter.insertList(
        notifications, OnConflictStrategy.replace);
  }
}

class _$RelationshipDao extends RelationshipDao {
  _$RelationshipDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _relationshipEntityInsertionAdapter = InsertionAdapter(
            database,
            'relationships',
            (RelationshipEntity item) => <String, Object?>{
                  'id': item.id,
                  'isFollowing': item.isFollowing ? 1 : 0,
                  'isFollowed': item.isFollowed ? 1 : 0,
                  'isBlocking': item.isBlocking ? 1 : 0,
                  'isBlocked': item.isBlocked ? 1 : 0,
                  'isMuting': item.isMuting ? 1 : 0,
                  'accountId': item.accountId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RelationshipEntity>
      _relationshipEntityInsertionAdapter;

  @override
  Future<List<RelationshipEntity>> findAllRelationships() async {
    return _queryAdapter.queryList('SELECT * FROM relationships',
        mapper: (Map<String, Object?> row) => RelationshipEntity(
            id: row['id'] as String,
            isFollowing: (row['isFollowing'] as int) != 0,
            isFollowed: (row['isFollowed'] as int) != 0,
            isBlocking: (row['isBlocking'] as int) != 0,
            isBlocked: (row['isBlocked'] as int) != 0,
            isMuting: (row['isMuting'] as int) != 0,
            accountId: row['accountId'] as String));
  }

  @override
  Future<RelationshipEntity?> findRelationshipById(String id) async {
    return _queryAdapter.query('SELECT * FROM relationships WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RelationshipEntity(
            id: row['id'] as String,
            isFollowing: (row['isFollowing'] as int) != 0,
            isFollowed: (row['isFollowed'] as int) != 0,
            isBlocking: (row['isBlocking'] as int) != 0,
            isBlocked: (row['isBlocked'] as int) != 0,
            isMuting: (row['isMuting'] as int) != 0,
            accountId: row['accountId'] as String),
        arguments: [id]);
  }

  @override
  Future<RelationshipEntity?> findRelationshipByAccountId(
      String accountId) async {
    return _queryAdapter.query(
        'SELECT * FROM relationships WHERE accountId = ?1',
        mapper: (Map<String, Object?> row) => RelationshipEntity(
            id: row['id'] as String,
            isFollowing: (row['isFollowing'] as int) != 0,
            isFollowed: (row['isFollowed'] as int) != 0,
            isBlocking: (row['isBlocking'] as int) != 0,
            isBlocked: (row['isBlocked'] as int) != 0,
            isMuting: (row['isMuting'] as int) != 0,
            accountId: row['accountId'] as String),
        arguments: [accountId]);
  }

  @override
  Future<void> deleteAllRelationships() async {
    await _queryAdapter.queryNoReturn('DELETE FROM relationships');
  }

  @override
  Future<void> insertRelationship(RelationshipEntity account) async {
    await _relationshipEntityInsertionAdapter.insert(
        account, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
