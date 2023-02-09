import 'package:floor/floor.dart';

@DatabaseView('SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size();', viewName: 'DATABASE_INFO')
class DatabaseInfo {
  final int size;
  DatabaseInfo({
    required this.size,
  });
}
