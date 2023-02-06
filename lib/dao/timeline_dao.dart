import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon_api/mastodon_api.dart';

@dao
abstract class TimelineDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatuses(List<StatusEntity> statuses);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachments(List<AttachmentEntity> attachments);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAccounts(List<AccountEntity> accounts);

  @transaction
  Future<void> saveTimelineStatuses(List<Status> statuses) async {
    List<StatusEntity> statusesEntries = [];
    List<AccountEntity> accountsEntries = [];
    List<AttachmentEntity> attachmentsEntries = [];

    for (var status in statuses) {
      statusesEntries.add(StatusEntity.fromModel(status));

      accountsEntries.add(AccountEntity.fromModel(status.account));

      for (var attachment in status.mediaAttachments) {
        attachmentsEntries
            .add(AttachmentEntity.fromModel(status.id, attachment));
      }

      if (status.reblog != null) {
        statusesEntries.add(StatusEntity.fromModel(status.reblog!));
        accountsEntries.add(AccountEntity.fromModel(status.reblog!.account));
        for (var attachment in status.reblog!.mediaAttachments) {
          attachmentsEntries
              .add(AttachmentEntity.fromModel(status.id, attachment));
        }
      }
    }

    await insertAccounts(accountsEntries);
    await insertStatuses(statusesEntries);
    await insertAttachments(attachmentsEntries);
  }
}
