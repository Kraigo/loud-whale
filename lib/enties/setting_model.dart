import 'package:floor/floor.dart';

@entity
class Setting {
  @primaryKey
  final String name;
  final String value;

  const Setting({
    required this.name,
    required this.value,
  });
}
