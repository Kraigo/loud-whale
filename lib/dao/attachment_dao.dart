import 'package:floor/floor.dart';
import 'package:mastodon/enties/attachment_entity.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class AttachmentDao {
  @Query('SELECT * FROM attachments WHERE id = :id')
  Stream<AttachmentEntity?> findAttachmentById(String id);

  @Query('SELECT * FROM attachments WHERE status_id = :statusId')
  Stream<List<AttachmentEntity>> findAttachemntsByStatus(String statusId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachment(AttachmentEntity attachment);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachments(List<AttachmentEntity> attachments);
}
