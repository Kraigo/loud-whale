import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class StatusDao {
  @Query('SELECT * FROM Status')
  Future<List<Status>> findAllStatuses();

  // @Query('SELECT * FROM Person WHERE id = :id')
  // Stream<Account?> findAccountById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatus(Status status);
}