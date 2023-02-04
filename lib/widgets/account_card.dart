import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/account_entity.dart';

import 'account_avatar.dart';

class AccountCard extends StatelessWidget {
  final AccountEntity account;
  const AccountCard(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            AccountAvatar(avatar: account.avatar),
            Column(
              children: [Text(account.displayName), Text(account.username)],
            )
          ],
        ),
        Html(data: account.note)
      ],
    ));
  }
}
