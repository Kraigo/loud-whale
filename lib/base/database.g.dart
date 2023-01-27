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
            'CREATE TABLE IF NOT EXISTS `Account` (`id` TEXT NOT NULL, `username` TEXT NOT NULL, `display_name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Status` (`id` TEXT NOT NULL, `content` TEXT NOT NULL, `account_id` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Setting` (`name` TEXT NOT NULL, `value` TEXT NOT NULL, PRIMARY KEY (`name`))');

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
}

class _$StatusDao extends StatusDao {
  _$StatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statusInsertionAdapter = InsertionAdapter(
            database,
            'Status',
            (Status item) => <String, Object?>{
                  'id': item.id,
                  'content': item.content,
                  'account_id': item.accountId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Status> _statusInsertionAdapter;

  @override
  Future<List<Status>> findAllStatuses() async {
    return _queryAdapter.queryList('SELECT * FROM Status',
        mapper: (Map<String, Object?> row) => Status(
            id: row['id'] as String,
            content: row['content'] as String,
            accountId: row['account_id'] as String));
  }

  @override
  Future<void> insertStatus(Status status) async {
    await _statusInsertionAdapter.insert(status, OnConflictStrategy.replace);
  }
}

class _$SettingDao extends SettingDao {
  _$SettingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _settingInsertionAdapter = InsertionAdapter(
            database,
            'Setting',
            (Setting item) =>
                <String, Object?>{'name': item.name, 'value': item.value});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Setting> _settingInsertionAdapter;

  @override
  Future<List<Setting>> findAllSettings() async {
    return _queryAdapter.queryList('SELECT * FROM Setting',
        mapper: (Map<String, Object?> row) => Setting(
            name: row['name'] as String, value: row['value'] as String));
  }

  @override
  Future<Setting?> findSettingByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Setting WHERE name = ?1',
        mapper: (Map<String, Object?> row) =>
            Setting(name: row['name'] as String, value: row['value'] as String),
        arguments: [name]);
  }

  @override
  Future<void> removeSettingByName(String name) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Setting WHERE name = ?1',
        arguments: [name]);
  }

  @override
  Future<void> insertSetting(Setting setting) async {
    await _settingInsertionAdapter.insert(setting, OnConflictStrategy.replace);
  }
}
