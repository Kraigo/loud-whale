import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/screens/reply_screen.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  final bool showMedia;
  final EdgeInsets padding;
  const StatusCard(
    this.status, {
    this.showMedia = true,
    this.padding = const EdgeInsets.all(8.0),
    super.key,
  });

  StatusEntity get actualStatus => status.reblog ?? status;

  _openThread(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.thread, arguments: {'statusId': actualStatus.id});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_openThread(context)},
      child: Padding(
        padding: padding,
        child: Column(children: [
          if (status.reblog != null) StatusCardReblogged(status.account!),
          StatusCardHeader(status),
          if (actualStatus.hasContent ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: StatusCardContent(actualStatus),
            ),
          if (actualStatus.mediaAttachments?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: StatusMedia(actualStatus.mediaAttachments ?? []),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: StatusCardActions(status),
          )
        ]),
      ),
    );
  }
}

class StatusCardHeader extends StatelessWidget {
  final StatusEntity status;
  const StatusCardHeader(this.status, {super.key});
  StatusEntity get actualStatus => status.reblog ?? status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusCardAccount(status),
        TimeAgo(actualStatus.createdAt),
      ],
    );
  }
}

class StatusCardAccount extends StatelessWidget {
  final StatusEntity status;
  const StatusCardAccount(this.status, {super.key});

  StatusEntity get actualStatus => status.reblog ?? status;
  AccountEntity get account => actualStatus.account!;

  String get displayName {
    var name = 'User';

    if (account.displayName.isNotEmpty) {
      name = account.displayName;
    } else {
      name = account.username;
    }

    return name;
  }

  _openProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.profile, arguments: {'accountId': account.id});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _openProfile(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (status.reblog == null)
              AccountAvatar(
                avatar: account.avatar,
              ),
            if (status.reblog != null)
              AccountAvatarReblogged(
                avatar: account.avatar,
                rebloggedAvatar: status.account!.avatar,
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
                  '@${account.acct}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            )
          ],
        ));
  }
}

class StatusCardContent extends StatelessWidget {
  final StatusEntity status;
  const StatusCardContent(this.status, {super.key});

  _openLink(String url) async {
    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(
          style: {
            'body': Style(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                lineHeight: LineHeight.em(1.4)),
            'p': Style(
              margin: const EdgeInsets.all(0),
            ),
            'a': Style(
              textDecoration: TextDecoration.none
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
            status: status.reblog ?? status,
          );
        });

    await timelineProvider.refresh();
  }

  _onReblog(BuildContext context) async {
    await context.read<TimelineProvider>().reblogStatus(status.id);
  }

  _onFavourute(BuildContext context) async {
    final timelineProvider = context.read<TimelineProvider>();
    if (status.isFavourited == true) {
      await timelineProvider.unfavoriteStatus(status.id);
    } else {
      await timelineProvider.favoriteStatus(status.id);
    }
  }

  _onShare(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          onPressed: () => _onReply(context),
          icon: const ActionIcon(icon: Icons.reply),
          label: status.repliesCount > 0 ? '${status.repliesCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onReblog(context),
          icon: ActionIcon(
            icon: Icons.repeat,
            isActivated: status.isReblogged,
          ),
          label: status.reblogsCount > 0 ? '${status.reblogsCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onFavourute(context),
          icon: ActionIcon(
            icon: status.isFavourited == true ? Icons.star : Icons.star_border,
            isActivated: status.isFavourited,
          ),
          label: status.favouritesCount > 0 ? '${status.favouritesCount}' : '',
        ),
        ActionButton(
          onPressed: () => _onShare(context),
          icon: const ActionIcon(icon: Icons.share),
        ),
        const Spacer(),
        StatusCardMenu(status)
      ],
    );
  }
}

class StatusCardReblogged extends StatelessWidget {
  final AccountEntity account;
  const StatusCardReblogged(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(account.displayName),
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

class StatusCardMenuItem {
  final String label;
  final IconData iconData;
  final void Function() onSelect;

  const StatusCardMenuItem({
    required this.label,
    required this.iconData,
    required this.onSelect,
  });
}

class StatusCardMenu extends StatelessWidget {
  final List<StatusCardMenuItem> menu;
  final StatusEntity status;
  StatusCardMenu(this.status, {super.key})
      : menu = [
          StatusCardMenuItem(
              label: 'Open link to post',
              iconData: Icons.open_in_new,
              onSelect: () async {
                await launchUrlString('${status.account!.url}/${status.id}');
              })
        ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: const ActionIcon(
        icon: Icons.more_vert,
      ),
      onSelected: (index) {
        final item = menu.elementAt(index);
        item.onSelect();
      },
      itemBuilder: (BuildContext context) => [
        for (var item in menu)
          PopupMenuItem(
            value: menu.indexOf(item),
            child: Row(
              children: [
                Icon(
                  item.iconData,
                  // color: Colors.black,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(item.label),
              ],
            ),
          )
      ],
    );
  }
}
