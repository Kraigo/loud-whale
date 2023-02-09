import 'package:floor/floor.dart';
import 'package:mastodon/enties/relationship_entity.dart';
import 'package:mastodon_api/mastodon_api.dart';

@Entity(tableName: 'accounts')
class AccountEntity {
  @primaryKey
  String id;
  String username;
  String displayName;
  String acct;
  String note;
  String url;
  String avatar;
  String avatarStatic;
  String header;
  String headerStatic;
  int followersCount;
  int followingCount;
  int? subscribingCount;
  int statusesCount;
  bool? isBot;
  // DateTime? lastStatusAt;
  DateTime createdAt;

  @ignore
  RelationshipEntity? relationship;

  AccountEntity(
      {required this.id,
      required this.username,
      required this.displayName,
      required this.acct,
      required this.note,
      required this.url,
      required this.avatar,
      required this.avatarStatic,
      required this.header,
      required this.headerStatic,
      required this.followersCount,
      required this.followingCount,
      this.subscribingCount,
      required this.statusesCount,
      this.isBot,
      // this.lastStatusAt,
      required this.createdAt});

  factory AccountEntity.fromModel(Account model) => AccountEntity(
        id: model.id,
        username: model.username,
        displayName: model.displayName,
        acct: model.acct,
        note: model.note,
        url: model.url,
        avatar: model.avatar,
        avatarStatic: model.avatarStatic,
        header: model.header,
        headerStatic: model.headerStatic,
        followersCount: model.followersCount,
        followingCount: model.followingCount,
        subscribingCount: model.subscribingCount,
        statusesCount: model.statusesCount,
        isBot: model.isBot,
        // lastStatusAt: model.lastStatusAt,
        createdAt: model.createdAt,
      );
}
