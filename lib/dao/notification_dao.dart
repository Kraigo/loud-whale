import 'package:floor/floor.dart';
import 'package:mastodon/enties/notification_entity.dart';

@dao
abstract class NotificationDao {
  @Query('''
    SELECT * FROM notifications
    WHERE id = :id
  ''')
  Future<NotificationEntity?> findNotification(String id);

  @Query('''
    SELECT * FROM notifications
    ORDER BY createdAt DESC
    LIMIT :limit
    OFFSET :skip
  ''')
  Future<List<NotificationEntity>> findNotifications(int limit, int skip);

  @Query('''
    SELECT COUNT(statusId) FROM notifications
  ''')
  Future<int?> countNotifications();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotification(NotificationEntity notification);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotifications(List<NotificationEntity> notifications);

  @Query('''
    DELETE FROM notifications
  ''')
  Future<void> deleteAllNotifications();

  @Query('''
    SELECT * FROM notifications
    ORDER BY createdAt ASC
    LIMIT 1
  ''')
  Future<NotificationEntity?> getOldestNotification();

  @Query('''
    SELECT * FROM notifications
    ORDER BY createdAt DESC
    LIMIT 1
  ''')
  Future<NotificationEntity?> getNewestNotification();

  @Query('''
    SELECT COUNT(id) FROM "notifications"
    WHERE createdAt > (
      SELECT createdAt FROM "notifications"
      WHERE id = :notificationId
      LIMIT 1
    )
  ''')
  Future<int?> countUnreadNotifications(String notificationId);
}
