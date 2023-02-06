import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  final StatusEntity? reblog;
  final bool showMedia;
  const StatusCard(
    this.status, {
    this.showMedia = true,
    this.reblog,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        if (reblog != null) StatusCardReblogged(reblog!),
        StatusCardContent(status),
        StatusMediaStream(status.id),
        const SizedBox(
          height: 10,
        ),
        StatusCardActions(status)
      ]),
    );
  }
}

class StatusCardContent extends StatelessWidget {
  final StatusEntity status;
  const StatusCardContent(this.status, {super.key});

  _openThread(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.thread, arguments: {'statusId': status.id});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusCardAuthor(status),
            TimeAgo(status.createdAt),
          ],
        ),
        GestureDetector(
          onTap: () => {_openThread(context)},
          child: Html(
              style: {
                'body': Style(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0))
              },
              data: status.content,
              onLinkTap: (url, context, attributes, element) {
                debugPrint(url);
              }),
        ),
      ],
    );
  }
}

class StatusCardStream extends StatelessWidget {
  final String statusId;
  final StatusEntity? reblog;
  const StatusCardStream({required this.statusId, this.reblog, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AppDatabase>().statusDao.findStatusById(statusId),
      builder: (context, snapshot) {
        final status = snapshot.data;
        if (status == null) {
          return const StatusCardPlaceholder();
        }

        return StatusCard(
          status,
          reblog: reblog,
        );
      },
    );
  }
}

class StatusCardActions extends StatelessWidget {
  final StatusEntity status;
  const StatusCardActions(this.status, {super.key});

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
          onPressed: () async {
            await context.read<TimelineProvider>().favoriteStatus(status.id);
          },
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

class StatusCardPlaceholder extends StatelessWidget {
  const StatusCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).hintColor),
      ),
    );
  }
}
