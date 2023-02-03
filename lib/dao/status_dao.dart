import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class StatusDao {
  @Query('''
  SELECT * FROM statuses
  WHERE isReblogged IS false AND inReplyToId IS NULL
  ORDER BY createdAt DESC
  ''')
  Future<List<StatusEntity>> findAllStatuses();

  @Query('SELECT * FROM statuses WHERE id = :id')
  Stream<StatusEntity?> findStatusById(String id);

  @Query('''
  WITH RECURSIVE 
    descendants(id, inReplyToId) AS (
      SELECT statuses.id, statuses.inReplyToId
      FROM statuses 
      WHERE statuses.inReplyToId = :id
      UNION ALL
      
      SELECT statuses.id, statuses.inReplyToId
      FROM descendants
      JOIN statuses ON descendants.id = statuses.inReplyToId
    )
    SELECT *
    FROM statuses
    WHERE id IN (
      SELECT id 
      FROM descendants
    )
    ORDER BY createdAt ASC
  ''')
  Stream<List<StatusEntity?>> findStatusReplies(String id);

  @Query('SELECT * FROM statuses WHERE inReplyTo = :id')
  Stream<StatusEntity?> findStatusReplied(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatus(StatusEntity status);
}