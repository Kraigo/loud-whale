import 'package:floor/floor.dart';
import 'package:mastodon_api/mastodon_api.dart';

import 'status_entity.dart';

@Entity(
  tableName: 'homeStatuses',
  foreignKeys: [
    ForeignKey(
      childColumns: ['statusId'],
      parentColumns: ['id'],
      entity: StatusEntity,
    ),
  ],
)
class StatusHomeEntity {
  @primaryKey
  String statusId;
  DateTime createdAt;

  StatusHomeEntity({
    required this.statusId,
    required this.createdAt,
  });

  factory StatusHomeEntity.fromModel(Status model) => StatusHomeEntity(
        statusId: model.id,
        createdAt: model.createdAt,
      );
}
