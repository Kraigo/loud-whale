import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class StatusDao {
  @Query('''
  SELECT * FROM statuses
  WHERE isReblogged IS false
    AND (inReplyToAccountId = statuses.accountId OR inReplyToId IS NULL)
    AND id NOT IN (
      SELECT reblogId FROM statuses as reblogs WHERE reblogs.reblogId = statuses.id
    )
  ORDER BY createdAt DESC
  LIMIT :limit
  OFFSET :skip
  ''')
  Future<List<StatusEntity>> findAllStatuses(int limit, int skip);

  @Query('''
  SELECT * FROM statuses
  WHERE id IN (
    SELECT statusId from homeStatuses
    ORDER BY createdAt DESC
    LIMIT :limit
    OFFSET :skip
  )
  ORDER BY createdAt DESC
  ''')
  Future<List<StatusEntity>> findAllHomeStatuses(int limit, int skip);

  @Query('''
  SELECT COUNT(statusId) FROM homeStatuses
  ''')
  Future<int?> countAllHomeStatuses();

  @Query('SELECT * FROM statuses WHERE id = :id')
  Future<StatusEntity?> findStatusById(String id);

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
  Future<List<StatusEntity>> findStatusRepliesDescendants(String id);

  @Query('''
  WITH RECURSIVE 
    descendants(id, inReplyToId) AS (
      SELECT statuses.id, statuses.inReplyToId
      FROM statuses 
      WHERE statuses.id = :id
      UNION ALL
      
      SELECT statuses.id, statuses.inReplyToId
      FROM descendants
      JOIN statuses ON descendants.inReplyToId = statuses.id
    )
    SELECT *
    FROM statuses
    WHERE id IN (
      SELECT id 
      FROM descendants
      WHERE id <> :id
    )
    ORDER BY createdAt ASC
  ''')
  Future<List<StatusEntity>> findStatusRepliesAncestors(String id);

  @Query('SELECT * FROM statuses WHERE inReplyTo = :id')
  Future<StatusEntity?> findStatusReplied(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatus(StatusEntity status);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatuses(List<StatusEntity> statuses);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertHomeStatuses(List<StatusHomeEntity> statuses);

  @Query('DELETE FROM statuses')
  Future<void> deleteAllStatuses();

  @Query('DELETE FROM homeStatuses')
  Future<void> deleteAllHomeStatuses();

  @Query('''
  SELECT * FROM statuses
  WHERE id IN (
    SELECT statusId from homeStatuses
    ORDER BY createdAt ASC
    LIMIT 1
  )
  ''')
  Future<StatusEntity?> getOldestStatus();
}
