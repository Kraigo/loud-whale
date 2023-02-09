import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/widgets/widgets.dart';

import 'account_avatar.dart';

class AccountCard extends StatelessWidget {
  final AccountEntity account;
  final Widget? actions;
  const AccountCard(
    this.account, {
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).disabledColor),
              child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    account.headerStatic,
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
        MiddleContainer(
          Column(
            children: [
              Row(
                children: [
                  AccountAvatar(avatar: account.avatar),
                  Column(
                    children: [
                      Text(account.displayName),
                      Text('@${account.username}')
                    ],
                  ),
                  Spacer(),
                  actions ?? Container()
                ],
              ),
              Html(data: account.note),
              Divider(),
              StatusesCount(account),
            ],
          ),
        )
      ],
    );
  }
}

class StatusesCount extends StatelessWidget {
  final AccountEntity account;
  const StatusesCount(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: '${account.statusesCount}'),
              TextSpan(
                  text: ' Posts', style: Theme.of(context).textTheme.caption)
            ]),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: '${account.followingCount}'),
              TextSpan(
                  text: ' Following',
                  style: Theme.of(context).textTheme.caption)
            ]),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: '${account.followersCount}'),
              TextSpan(
                  text: ' Followers',
                  style: Theme.of(context).textTheme.caption)
            ]),
          ),
        ),
      ],
    );
  }
}
