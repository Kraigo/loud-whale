import 'package:floor/floor.dart';

@entity
class Account {
  @primaryKey
  String id;
  String username;
  String display_name;
  
  Account({
    required this.id,
    required this.username,
    required this.display_name,
  });
}
