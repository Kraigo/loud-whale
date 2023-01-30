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
            'CREATE TABLE IF NOT EXISTS `statuses` (`id` TEXT NOT NULL, `url` TEXT, `uri` TEXT NOT NULL, `content` TEXT NOT NULL, `spoilerText` TEXT NOT NULL, `visibility` TEXT NOT NULL, `favouritesCount` INTEGER NOT NULL, `repliesCount` INTEGER NOT NULL, `reblogsCount` INTEGER NOT NULL, `language` TEXT, `inReplyToId` TEXT, `inReplyToAccountId` TEXT, `isFavourited` INTEGER, `isReblogged` INTEGER, `isMuted` INTEGER, `isBookmarked` INTEGER, `isSensitive` INTEGER, `isPinned` INTEGER, `createdAt` INTEGER NOT NULL, `reblogId` TEXT, `account_id` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `settings` (`name` TEXT NOT NULL, `value` TEXT NOT NULL, PRIMARY KEY (`name`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `attachments` (`id` TEXT NOT NULL, `status_id` TEXT NOT NULL, `type` INTEGER NOT NULL, `url` TEXT NOT NULL, `previewUrl` TEXT NOT NULL, `remoteUrl` TEXT, `description` TEXT, FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');

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
}

class _$StatusDao extends StatusDao {
  _$StatusDao(
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
                  'account_id': item.accountId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StatusEntity> _statusEntityInsertionAdapter;

  @override
  Future<List<StatusEntity>> findAllStatuses() async {
    return _queryAdapter.queryList(
        'SELECT * FROM statuses WHERE isReblogged IS false ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
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
            accountId: row['account_id'] as String));
  }

  @override
  Stream<StatusEntity?> findStatusById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM statuses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StatusEntity(
            id: row['id'] as String,
            url: row['url'] as String?,
            uri: row['uri'] as String,
            content: row['content'] as String,
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
            accountId: row['account_id'] as String),
        arguments: [id],
        queryableName: 'statuses',
        isView: false);
  }

  @override
  Future<void> insertStatus(StatusEntity status) async {
    await _statusEntityInsertionAdapter.insert(
        status, OnConflictStrategy.replace);
  }
}

class _$SettingDao extends SettingDao {
  _$SettingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _settingInsertionAdapter = InsertionAdapter(
            database,
            'settings',
            (Setting item) =>
                <String, Object?>{'name': item.name, 'value': item.value});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Setting> _settingInsertionAdapter;

  @override
  Future<List<Setting>> findAllSettings() async {
    return _queryAdapter.queryList('SELECT * FROM settings',
        mapper: (Map<String, Object?> row) => Setting(
            name: row['name'] as String, value: row['value'] as String));
  }

  @override
  Future<Setting?> findSettingByName(String name) async {
    return _queryAdapter.query('SELECT * FROM settings WHERE name = ?1',
        mapper: (Map<String, Object?> row) =>
            Setting(name: row['name'] as String, value: row['value'] as String),
        arguments: [name]);
  }

  @override
  Future<void> removeSettingByName(String name) async {
    await _queryAdapter.queryNoReturn('DELETE FROM settings WHERE name = ?1',
        arguments: [name]);
  }

  @override
  Future<void> insertSetting(Setting setting) async {
    await _settingInsertionAdapter.insert(setting, OnConflictStrategy.replace);
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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccountEntity> _accountEntityInsertionAdapter;

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
  Stream<AccountEntity?> findAccountById(String id) {
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
  Future<void> insertAccount(AccountEntity account) async {
    await _accountEntityInsertionAdapter.insert(
        account, OnConflictStrategy.replace);
  }
}

class _$AttachmentDao extends AttachmentDao {
  _$AttachmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _attachmentEntityInsertionAdapter = InsertionAdapter(
            database,
            'attachments',
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'status_id': item.statusId,
                  'type': item.type,
                  'url': item.url,
                  'previewUrl': item.previewUrl,
                  'remoteUrl': item.remoteUrl,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentEntity> _attachmentEntityInsertionAdapter;

  @override
  Stream<AttachmentEntity?> findAttachmentById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM attachments WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['status_id'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [id],
        queryableName: 'attachments',
        isView: false);
  }

  @override
  Stream<List<AttachmentEntity>> findAttachemntsByStatus(String statusId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM attachments WHERE status_id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            statusId: row['status_id'] as String,
            id: row['id'] as String,
            type: row['type'] as int,
            url: row['url'] as String,
            previewUrl: row['previewUrl'] as String,
            remoteUrl: row['remoteUrl'] as String?,
            description: row['description'] as String?),
        arguments: [statusId],
        queryableName: 'attachments',
        isView: false);
  }

  @override
  Future<void> insertAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityInsertionAdapter.insert(
        attachment, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
