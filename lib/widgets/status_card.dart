import 'package:flutter/material.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/thread_provider.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/screens/reply_screen.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  final bool showMedia;
  final EdgeInsets padding;
  final bool? collapsed;
  final bool disabledThread;
  final bool showActionHeader;
  const StatusCard(
    this.status, {
    this.showMedia = true,
    this.collapsed,
    this.disabledThread = false,
    this.showActionHeader = false,
    this.padding = const EdgeInsets.all(8.0),
    super.key,
  });

  StatusEntity get actualStatus => status.reblog ?? status;

  _openThread(BuildContext context) async {
    final statusId = actualStatus.id;
    await context.read<ThreadProvider>().refresh(statusId);
    await Navigator.of(context)
        .pushNamed(Routes.thread, arguments: {'statusId': statusId});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabledThread ? null : () => _openThread(context),
      child: Padding(
        padding: padding,
        child: Column(children: [
          if (showActionHeader) ...[
            if (status.reblog != null) StatusCardReblogged(status.account!),
            if (status.inReplyToAccount != null)
              StatusCardReplied(status.inReplyToAccount!),
          ],
          StatusCardHeader(status),
          if (actualStatus.hasContent ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: StatusCardContent(
                actualStatus,
                collapsed: collapsed,
              ),
            ),
          if (actualStatus.mediaAttachments?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: StatusMedia(actualStatus.mediaAttachments ?? []),
            ),
          if (actualStatus.poll != null) StatusPoll(poll: actualStatus.poll!),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: StatusCardActions(actualStatus),
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

class StatusCardContent extends StatefulWidget {
  final StatusEntity status;
  final bool collapsed;

  const StatusCardContent(this.status, {collapsed, super.key})
      : collapsed = collapsed ?? false;

  @override
  State<StatusCardContent> createState() => _StatusCardContentState();
}

class _StatusCardContentState extends State<StatusCardContent> {
  late ScrollController scrollController;
  bool showMore = false;

  @override
  void initState() {
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        showMore = scrollController.position.maxScrollExtent > 0;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = widget.collapsed ? 300.0 : double.infinity;

    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: StatusHTML(
              data: widget.status.content,
            ),
          ),
        ),
        if (showMore)
          const Positioned(
            height: 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: _MoreGradient(),
          )
      ],
    );
  }
}

class _MoreGradient extends StatelessWidget {
  const _MoreGradient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).cardColor.withOpacity(0.5),
          Theme.of(context).cardColor,
        ],
      )),
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

  _openProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.profile, arguments: {'accountId': account.id});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProfile(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .labelMedium!
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
      ),
    );
  }
}

class StatusCardReplied extends StatelessWidget {
  final AccountEntity account;
  const StatusCardReplied(this.account, {super.key});

  _openProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Routes.profile, arguments: {'accountId': account.id});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProfile(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold),
            child: Row(
              children: [
                Icon(
                  Icons.reply,
                  size: 14,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text("Replied to"),
                const SizedBox(
                  width: 4,
                ),
                Text(account.displayName),
              ],
            )),
      ),
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
