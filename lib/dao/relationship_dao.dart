import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/enties/relationship_entity.dart';

@dao
abstract class RelationshipDao {
  @Query('SELECT * FROM relationships')
  Future<List<RelationshipEntity>> findAllRelationships();

  @Query('SELECT * FROM relationships WHERE id = :id')
  Future<RelationshipEntity?> findRelationshipById(String id);

  @Query('SELECT * FROM relationships WHERE accountId = :accountId')
  Future<RelationshipEntity?> findRelationshipByAccountId(String accountId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRelationship(RelationshipEntity account);

  @Query('DELETE FROM relationships')
  Future<void> deleteAllRelationships();
}
