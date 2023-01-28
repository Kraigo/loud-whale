import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class AccountDao {
  @Query('SELECT * FROM accounts')
  Future<List<AccountEntity>> findAllAccountes();

  @Query('SELECT * FROM accounts WHERE id = :id')
  Stream<AccountEntity?> findAccountById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAccount(AccountEntity account);
}