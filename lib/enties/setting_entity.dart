import 'package:floor/floor.dart';

@Entity(tableName: 'settings')
class SettingEntity {
  @primaryKey
  final String name;
  final String value;

  const SettingEntity({
    required this.name,
    required this.value,
  });
}
