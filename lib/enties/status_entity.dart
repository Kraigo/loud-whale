import 'package:floor/floor.dart';
import 'package:mastodon_api/mastodon_api.dart';

@Entity(tableName: 'statuses')
class StatusEntity {
  @primaryKey
  String id;
  String? url;
  String uri;
  String content;

  String spoilerText;
  String visibility;
  int favouritesCount;
  int repliesCount;
  int reblogsCount;
  String? language;
  String? inReplyToId;
  String? inReplyToAccountId;
  bool? isFavourited;
  bool? isReblogged;
  bool? isMuted;
  bool? isBookmarked;
  bool? isSensitive;
  bool? isPinned;
  // DateTime? lastStatusAt;
  DateTime createdAt;

  String? reblogId;

  @ColumnInfo(name: 'account_id')
  String accountId;

  StatusEntity({
    required this.id,
    this.url,
    required this.uri,
    required this.content,
    required this.spoilerText,
    required this.visibility,
    required this.favouritesCount,
    required this.repliesCount,
    required this.reblogsCount,
    this.language,
    this.inReplyToId,
    this.inReplyToAccountId,
    this.isFavourited,
    this.isReblogged,
    this.isMuted,
    this.isBookmarked,
    this.isSensitive,
    this.isPinned,
    // this.lastStatusAt,
    this.reblogId,
    required this.createdAt,
    required this.accountId,
  });

  factory StatusEntity.fromModel(Status model) => StatusEntity(
        id: model.id,
        url: model.url,
        uri: model.uri,
        content: model.content,
        spoilerText: model.spoilerText,
        visibility: model.visibility.value,
        favouritesCount: model.favouritesCount,
        repliesCount: model.repliesCount,
        reblogsCount: model.reblogsCount,
        language: model.language?.value,
        inReplyToId: model.inReplyToId,
        inReplyToAccountId: model.inReplyToAccountId,
        isFavourited: model.isFavourited,
        isReblogged: model.isReblogged,
        isMuted: model.isMuted,
        isBookmarked: model.isBookmarked,
        isSensitive: model.isSensitive,
        isPinned: model.isPinned,
        // lastStatusAt: model.lastStatusAt,
        reblogId: model.reblog?.id,
        createdAt: model.createdAt,
        accountId: model.account.id,
      );
}
