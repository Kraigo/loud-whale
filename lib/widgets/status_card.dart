import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  const StatusCard(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatusCardAuthor(status),
          TimeAgo(status.createdAt),
        ],
      ),
      Html(
          data: status.content,
          onLinkTap: (url, context, attributes, element) {
            debugPrint(url);
          }),
      _StatusCardActions()
    ]);
  }
}

class _StatusCardAuthor extends StatelessWidget {
  final StatusEntity status;
  const _StatusCardAuthor(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            context.read<TimelineProvider>().getAccountById(status.accountId),
        builder: (context, snapshot) {
          final account = snapshot.data;

          var displayName = 'User';

          if (account?.displayName.isNotEmpty ?? false) {
            displayName = snapshot.data!.displayName;
          }
          if (account?.displayName.isEmpty ?? false) {
            displayName = snapshot.data!.username;
          }

          return Row(children: [
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
                  account?.acct ?? '',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            )
          ]);
        });
  }
}

class _StatusCardActions extends StatelessWidget {
  const _StatusCardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.reply)),
        IconButton(onPressed: () {}, icon: Icon(Icons.repeat)),
        IconButton(onPressed: () {}, icon: Icon(Icons.star)),
        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }
}
