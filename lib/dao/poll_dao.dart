import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class PollDao {
  @Query('SELECT * FROM polls WHERE statusId = :statusId')
  Future<PollEntity?> findPollByStatustId(String statusId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPoll(PollEntity poll);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPolls(List<PollEntity> polls);

  @Query('DELETE FROM polls')
  Future<void> deleteAllPoll();
}
