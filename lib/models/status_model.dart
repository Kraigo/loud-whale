import 'package:floor/floor.dart';

import 'account_model.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['account_id'],
      parentColumns: ['id'],
      entity: Account,
    )
  ],
)
class Status {
  @primaryKey
  String id;
  String content;
  
  @ColumnInfo(name: 'account_id')
  String accountId;

  Status({
    required this.id,
    required this.content,
    required this.accountId,
  });
}


