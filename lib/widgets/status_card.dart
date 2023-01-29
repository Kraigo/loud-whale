import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  final StatusEntity? reblog;
  const StatusCard(this.status, {this.reblog, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (reblog != null) _StatusCardReblogged(reblog!),
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
      _StatusCardMedia(status),
      _StatusCardActions(status)
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

          return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
        });
  }
}

class _StatusCardReblogged extends StatelessWidget {
  final StatusEntity status;
  const _StatusCardReblogged(this.status, {super.key});

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

class _StatusCardActions extends StatelessWidget {
  final StatusEntity status;
  const _StatusCardActions(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          onPressed: () {},
          icon: Icons.reply,
          label: status.repliesCount > 0 ? '${status.repliesCount}' : '',
          // style: ButtonStyle(textStyle: Theme.of(context).textTheme.caption),
        ),
        ActionButton(
          onPressed: () {},
          icon: Icons.repeat,
          isActivated: status.isReblogged,
          label: status.reblogsCount > 0 ? '${status.reblogsCount}' : '',
        ),
        ActionButton(
          onPressed: () {},
          icon: status.isFavourited == true ? Icons.star : Icons.star_border,
          isActivated: status.isFavourited,
          label: status.favouritesCount > 0 ? '${status.favouritesCount}' : '',
        ),
        ActionButton(
          onPressed: () {},
          icon: Icons.share,
        ),
        Spacer(),
        ActionButton(
          onPressed: () {},
          icon: Icons.more_vert,
        )
      ],
    );
  }
}

class _StatusCardMedia extends StatelessWidget {
  final StatusEntity status;
  const _StatusCardMedia(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          context.read<TimelineProvider>().getAttachmentsByStatus(status.id),
      builder: (context, snapshot) {
        return Column(
            children: snapshot.data!.map((e) => Text(e.previewUrl)).toList());
      },
    );
  }
}
