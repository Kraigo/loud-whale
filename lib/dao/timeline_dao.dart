import 'package:floor/floor.dart';
import 'package:mastodon/dao/account_dao.dart';
import 'package:mastodon/dao/attachment_dao.dart';
import 'package:mastodon/dao/notification_dao.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon_api/mastodon_api.dart';

@dao
abstract class TimelineDao
    with StatusDao, AccountDao, AttachmentDao, NotificationDao {
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

  Future<NotificationEntity?> populateNotification(
    NotificationEntity? notification,
  ) async {
    if (notification == null) return null;

    notification.account = await findAccountById(notification.accountId);

    if (notification.statusId != null) {
      notification.status = await findStatusById(notification.statusId!);
    }

    if (notification.status?.accountId != null) {
      notification.status!.account =
          await findAccountById(notification.status!.accountId);
    }

    return notification;
  }

  Future<StatusEntity?> populateStatus(
    StatusEntity? status,
  ) async {
    if (status == null) return null;

    status.account = await findAccountById(status.accountId);

    if (status.reblogId != null) {
      status.reblog = await findStatusById(status.reblogId!);
    }

    if (status.reblog?.accountId != null) {
      status.reblog!.account =
          await findAccountById(status.reblog!.accountId);
    }
    status.mediaAttachments = await findAttachemntsByStatus(status.id);

    return status;
  }
}
