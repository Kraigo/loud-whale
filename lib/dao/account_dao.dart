import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class AccountDao {
  @Query('SELECT * FROM Account')
  Future<List<Account>> findAllAccountes();

  @Query('SELECT * FROM Account WHERE id = :id')
  Stream<Account?> findAccountById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAccount(Account account);
}