import 'package:floor/floor.dart';
import 'package:mastodon/enties/entries.dart';

@dao
abstract class AccountDao {
  @Query('SELECT * FROM accounts')
  Future<List<AccountEntity>> findAllAccountes();

  @Query('SELECT * FROM accounts WHERE id = :id')
  Future<AccountEntity?> findAccountById(String id);

  @Query('SELECT * FROM accounts WHERE id = :id')
  Stream<AccountEntity?> findAccountByIdStream(String id);

  @Query(
      'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')')
  Future<AccountEntity?> findCurrentAccount();

  @Query(
      'SELECT * FROM accounts WHERE id IN (SELECT value FROM settings WHERE settings.name = \'userId\')')
  Stream<AccountEntity?> findCurrentAccountStream();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAccount(AccountEntity account);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAccounts(List<AccountEntity> accounts);
}
