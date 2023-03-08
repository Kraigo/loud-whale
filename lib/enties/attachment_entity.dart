import 'package:floor/floor.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon_api/mastodon_api.dart';

@Entity(
  tableName: 'attachments',
  foreignKeys: [
    ForeignKey(
      childColumns: ['statusId'],
      parentColumns: ['id'],
      entity: StatusEntity,
    )
  ],
)
class AttachmentEntity {
  @primaryKey
  String id;
  String statusId;
  int type;
  String url;
  String previewUrl;
  String? remoteUrl;
  String? description;

  AttachmentEntity({
    required this.statusId,
    required this.id,
    required this.type,
    required this.url,
    required this.previewUrl,
    this.remoteUrl,
    this.description,
  });

  factory AttachmentEntity.fromModel(String statusId, MediaAttachment media) =>
      AttachmentEntity(
        statusId: statusId,
        id: media.id,
        type: media.type.index,
        url: media.url ?? media.previewUrl,
        previewUrl: media.previewUrl,
        remoteUrl: media.remoteUrl,
        description: media.description,
      );
}
