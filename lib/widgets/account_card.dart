import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/widgets/widgets.dart';

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
    final avatarSize = 100.0;
    return SingleChildScrollView(
      child: Column(
        children: [
          _AccountCover(account: account),
          MiddleContainer(
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: avatarSize,
                          ),
                          Positioned(
                            top: avatarSize * 0.5 * -1,
                            child: AccountAvatar(
                              avatar: account.avatar,
                              size: avatarSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.displayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text('@${account.username}',
                              style: Theme.of(context).textTheme.labelMedium)
                        ],
                      ),
                      const Spacer(),
                      actions ?? Container()
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Html(
                  data: account.note,
                  style: {
                    'body': Style(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                    ),
                    'p': Style(
                      
                      margin: const EdgeInsets.all(0),
                    ),
                    'a': Style(
                      textDecoration: TextDecoration.none,
                    )
                  },
                ),
                const Divider(),
                StatusesCount(account),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AccountCover extends StatelessWidget {
  const _AccountCover({
    super.key,
    required this.account,
  });

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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
                  text: ' Posts', style: Theme.of(context).textTheme.labelSmall)
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
                  style: Theme.of(context).textTheme.labelSmall)
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
                  style: Theme.of(context).textTheme.labelSmall)
            ]),
          ),
        ),
      ],
    );
  }
}
