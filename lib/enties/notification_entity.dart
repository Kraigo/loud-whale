import 'package:floor/floor.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon_api/mastodon_api.dart';

@Entity(
  tableName: 'notifications',
  // foreignKeys: [
  //   ForeignKey(
  //     childColumns: ['accountId'],
  //     parentColumns: ['id'],
  //     entity: AccountEntity,
  //   ),
  //   ForeignKey(
  //     childColumns: ['statusId'],
  //     parentColumns: ['id'],
  //     entity: StatusEntity,
  //   )
  // ],
)
class NotificationEntity {
  @primaryKey
  final String id;
  final String type;
  final DateTime createdAt;
  final String accountId;
  final String? statusId;
  // Report? report;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.accountId,
    this.statusId,
  });

  factory NotificationEntity.fromModel(Notification model) =>
      NotificationEntity(
        id: model.id,
        type: model.type.value,
        createdAt: model.createdAt,
        accountId: model.account.id,
        statusId: model.status?.id,
      );
}
