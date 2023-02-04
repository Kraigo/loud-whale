import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

class StatusCardAuthor extends StatelessWidget {
  final StatusEntity status;
  const StatusCardAuthor(this.status, {super.key});

  _openProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.profile, arguments: {'accountId': status.accountId});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProfile(context),
      child: StreamBuilder(
          stream: context
              .read<AppDatabase>()
              .accountDao
              .findAccountById(status.accountId),
          builder: (context, snapshot) {
            final account = snapshot.data;

            var displayName = 'User';

            if (account?.displayName.isNotEmpty ?? false) {
              displayName = snapshot.data!.displayName;
            }
            if (account?.displayName.isEmpty ?? false) {
              displayName = snapshot.data!.username;
            }

            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AccountAvatar(
                    avatar: account?.avatar,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '@${account?.acct ?? ''}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  )
                ]);
          }),
    );
  }
}

class StatusCardReblogged extends StatelessWidget {
  final StatusEntity status;
  const StatusCardReblogged(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context
            .read<AppDatabase>()
            .accountDao
            .findAccountById(status.accountId),
        builder: (context, snapshot) {
          final account = snapshot.data;

          var displayName = 'User';

          if (account?.displayName.isNotEmpty ?? false) {
            displayName = snapshot.data!.displayName;
          }
          if (account?.displayName.isEmpty ?? false) {
            displayName = snapshot.data!.username;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.bold),
                child: Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      size: 14,
                      color: Theme.of(context).hintColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(displayName),
                    SizedBox(
                      width: 4,
                    ),
                    Text("boosted")
                  ],
                )),
          );
        });
  }
}
