import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/constants.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/screens/reply_screen.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  // final StatusEntity? reblog;
  final bool showMedia;
  final EdgeInsets padding;
  const StatusCard(
    this.status, {
    this.showMedia = true,
    // this.reblog,
    this.padding = const EdgeInsets.all(8.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final actualStatus = status.reblog ?? status;
    return Padding(
      padding: padding,
      child: Column(children: [
        if (status.reblog != null) StatusCardReblogged(status.account!),
        StatusCardContent(actualStatus),
        if (actualStatus.mediaAttachments?.isNotEmpty ?? false)
          StatusMedia(actualStatus.mediaAttachments ?? []),
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
  final bool showAccount;
  const StatusCardContent(this.status, {this.showAccount = true, super.key});

  _openThread(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.thread, arguments: {'statusId': status.id});
  }

  _openLink(String url) async {
    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAccount)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusCardAuthor(status.account!),
              TimeAgo(status.createdAt),
            ],
          ),
        GestureDetector(
          onTap: () => {_openThread(context)},
          child: Html(
            style: {
              'body': Style(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
              )
            },
            data: status.content,
            onLinkTap: (url, context, attributes, element) {
              debugPrint(url);
              if (url != null) {
                _openLink(url);
              }
            },
          ),
        ),
      ],
    );
  }
}

class StatusCardActions extends StatelessWidget {
  final StatusEntity status;
  const StatusCardActions(this.status, {super.key});

  _onReply(BuildContext context) async {
    final timelineProvider = context.read<TimelineProvider>();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReplyDialog(
            status: status,
          );
        });

    await timelineProvider.refresh();
  }

  _onReblog(BuildContext context) async {
    await context.read<TimelineProvider>().reblogStatus(status.id);
  }

  _onFavourute(BuildContext context) async {
    if (status.isFavourited == true) {
      await context.read<TimelineProvider>().unfavoriteStatus(status.id);
    } else {
      await context.read<TimelineProvider>().favoriteStatus(status.id);
    }
  }

  _onShare(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          onPressed: () => _onReply(context),
          icon: Icons.reply,
          label: status.repliesCount > 0 ? '${status.repliesCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onReblog(context),
          icon: Icons.repeat,
          isActivated: status.isReblogged,
          label: status.reblogsCount > 0 ? '${status.reblogsCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onFavourute(context),
          icon: status.isFavourited == true ? Icons.star : Icons.star_border,
          isActivated: status.isFavourited,
          label: status.favouritesCount > 0 ? '${status.favouritesCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onShare(context),
          icon: Icons.share,
        ),
        const Spacer(),
        ActionButton(
          onPressed: () {},
          icon: Icons.more_vert,
        )
      ],
    );
  }
}

class StatusCardAuthor extends StatelessWidget {
  final AccountEntity account;
  const StatusCardAuthor(this.account, {super.key});

  _openProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.profile, arguments: {'accountId': account.id});
  }

  @override
  Widget build(BuildContext context) {
    var displayName = 'User';

    if (account.displayName.isNotEmpty ?? false) {
      displayName = account.displayName;
    }
    if (account.displayName.isEmpty ?? false) {
      displayName = account.username;
    }

    return GestureDetector(
        onTap: () => _openProfile(context),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          AccountAvatar(
            avatar: account.avatar,
          ),
          const SizedBox(
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
                '@${account.acct ?? ''}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          )
        ]));
  }
}

class StatusCardReblogged extends StatelessWidget {
  final AccountEntity account;
  const StatusCardReblogged(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    var displayName = 'User';

    if (account.displayName.isNotEmpty ?? false) {
      displayName = account.displayName;
    }
    if (account.displayName.isEmpty ?? false) {
      displayName = account.username;
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
              const SizedBox(
                width: 4,
              ),
              Text(displayName),
              const SizedBox(
                width: 4,
              ),
              const Text("boosted")
            ],
          )),
    );
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
        decoration: BoxDecoration(color: Theme.of(context).disabledColor),
      ),
    );
  }
}
