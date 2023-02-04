import 'package:floor/floor.dart';
import 'package:mastodon/enties/setting_entity.dart';

@dao
abstract class SettingDao {
  @Query('SELECT * FROM settings')
  Future<List<SettingEntity>> findAllSettings();

  @Query('SELECT * FROM settings WHERE name = :name')
  Future<SettingEntity?> findSettingByName(String name);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSetting(SettingEntity setting);

  @Query('DELETE FROM settings WHERE name = :name')
  Future<void> removeSettingByName(String name);
}