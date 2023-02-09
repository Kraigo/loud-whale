import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/enties/setting_entity.dart';

@dao
abstract class SettingDao {
  @Query('SELECT * FROM settings')
  Future<List<SettingEntity>> findAllSettings();

  @Query('SELECT * FROM settings WHERE name = :name')
  Future<SettingEntity?> findSettingByName(String name);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSetting(SettingEntity setting);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSettings(List<SettingEntity> settings);

  @Query('DELETE FROM settings WHERE name = :name')
  Future<void> removeSettingByName(String name);

  @Query('SELECT * FROM DATABASE_INFO')
  Future<DatabaseInfo?> findDatabaseSize();

  @Query('DELETE FROM settings')
  Future<void> deleteAllSettings();

  @Query('vacuum')
  Future<void> vacuum();


}