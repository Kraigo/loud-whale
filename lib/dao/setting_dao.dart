import 'package:floor/floor.dart';
import 'package:mastodon/enties/setting_model.dart';

@dao
abstract class SettingDao {
  @Query('SELECT * FROM Setting')
  Future<List<Setting>> findAllSettings();

  @Query('SELECT * FROM Setting WHERE name = :name')
  Future<Setting?> findSettingByName(String name);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSetting(Setting setting);

  @Query('DELETE FROM Setting WHERE name = :name')
  Future<void> removeSettingByName(String name);
}