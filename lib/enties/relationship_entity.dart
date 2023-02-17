import 'package:floor/floor.dart';
// ignore: implementation_imports
import 'package:mastodon_api/src/service/entities/relationship.dart';

@Entity(
  tableName: 'relationships',
)
class RelationshipEntity {
  @primaryKey
  String id;
  bool isFollowing;
  bool isFollowed;
  bool isBlocking;
  bool isBlocked;
  bool isMuting;

  String accountId;

  RelationshipEntity({
    required this.id,
    required this.isFollowing,
    required this.isFollowed,
    required this.isBlocking,
    required this.isBlocked,
    required this.isMuting,
    required this.accountId
  });

  factory RelationshipEntity.fromModel(String accountId, Relationship model) =>
      RelationshipEntity(
        id: model.id,
        isFollowing: model.isFollowing,
        isFollowed: model.isFollowed,
        isBlocking: model.isBlocking,
        isBlocked: model.isBlocked,
        isMuting: model.isMuting,
        accountId: accountId
      );
}
