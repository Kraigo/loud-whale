import 'package:floor/floor.dart';
import 'package:mastodon/enties/attachment_entity.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class AttachmentDao {
  @Query('SELECT * FROM attachments WHERE id = :id')
  Future<AttachmentEntity?> findAttachmentById(String id);

  @Query('SELECT * FROM attachments WHERE statusId = :statusId')
  Future<List<AttachmentEntity>> findAttachemntsByStatus(String statusId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachment(AttachmentEntity attachment);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachments(List<AttachmentEntity> attachments);

  @Query('DELETE FROM attachments')
  Future<void> deleteAllAttachments();
}
