import 'package:floor/floor.dart';
import 'package:mastodon/enties/notification_entity.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM notifications')
  Future<List<NotificationEntity>> findAllNotifications();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotification(NotificationEntity notification);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotifications(List<NotificationEntity> notifications);
}
