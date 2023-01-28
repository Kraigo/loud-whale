import 'package:floor/floor.dart';

@Entity(tableName: 'settings')
class Setting {
  @primaryKey
  final String name;
  final String value;

  const Setting({
    required this.name,
    required this.value,
  });
}
