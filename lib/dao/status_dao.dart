import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class StatusDao {
  @Query('SELECT * FROM statuses WHERE isReblogged IS false ORDER BY createdAt DESC')
  Future<List<StatusEntity>> findAllStatuses();

  @Query('SELECT * FROM statuses WHERE id = :id')
  Stream<StatusEntity?> findStatusById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatus(StatusEntity status);
}