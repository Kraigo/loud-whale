import 'package:floor/floor.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/attachment_entity.dart';
import 'package:mastodon_api/mastodon_api.dart';

import 'poll_entity.dart';

@Entity(
  tableName: 'statuses',
  foreignKeys: [
    ForeignKey(
      childColumns: ['accountId'],
      parentColumns: ['id'],
      entity: AccountEntity,
    ),
  ],
)
class StatusEntity {
  @primaryKey
  String id;
  String? url;
  String uri;
  String content;
  bool? hasContent;

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

  @ignore
  StatusEntity? reblog;
  String? reblogId;

  @ignore
  AccountEntity? account;
  String accountId;

  @ignore
  List<AttachmentEntity>? mediaAttachments;
  
  @ignore
  PollEntity? poll;

  StatusEntity({
    required this.id,
    this.url,
    required this.uri,
    required this.content,
    required this.hasContent,
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
        hasContent: model.content
            .replaceAll(RegExp(r'<[^>]+>'), '')
            .replaceAll(RegExp('\u2063', unicode: true), '')
            .isNotEmpty,
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
