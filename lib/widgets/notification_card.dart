import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:mastodon/base/routes.dart';
import 'package:mastodon/base/theme.dart';
import 'package:mastodon/enties/entries.dart';

import 'account_avatar.dart';
import 'status_card.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final NotificationEntity notification;
  final bool truncatedStatus;
  final bool isUnread;

  factory NotificationCard(NotificationEntity notification,
      {isUnread = false}) {
    switch (notification.type) {
      case 'mention':
        return NotificationCard.mention(notification, isUnread: isUnread);
      case 'reblog':
        return NotificationCard.reblog(notification, isUnread: isUnread);
      case 'follow':
        return NotificationCard.follow(notification, isUnread: isUnread);
      case 'follow_request':
        return NotificationCard.follow(notification, isUnread: isUnread);
      case 'favourite':
        return NotificationCard.favourite(notification, isUnread: isUnread);
      default:
        return NotificationCard.regular(notification, isUnread: isUnread);
    }
  }

  const NotificationCard.regular(
    this.notification, {
    this.isUnread = false,
    super.key,
  })  : icon = Icons.notifications,
        iconColor = AppTheme.followColor,
        truncatedStatus = true;

  const NotificationCard.favourite(
    this.notification, {
    this.isUnread = false,
    super.key,
  })  : icon = Icons.star,
        iconColor = AppTheme.favouriteColor,
        truncatedStatus = true;

  const NotificationCard.reblog(
    this.notification, {
    this.isUnread = false,
    super.key,
  })  : icon = Icons.repeat,
        iconColor = AppTheme.reblogColor,
        truncatedStatus = true;

  const NotificationCard.follow(
    this.notification, {
    this.isUnread = false,
    super.key,
  })  : icon = Icons.person,
        iconColor = AppTheme.followColor,
        truncatedStatus = true;

  const NotificationCard.mention(
    this.notification, {
    this.isUnread = false,
    super.key,
  })  : icon = Icons.reply,
        iconColor = AppTheme.followColor,
        truncatedStatus = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            if (isUnread)
              const Icon(
                Icons.fiber_new_outlined,
              ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: truncatedStatus
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (notification.account != null)
                          Expanded(child: _NotificationAccount(notification)),
                        _NotificationDate(notification),
                      ],
                    ),
                    if (notification.status != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _NotificationStatus(notification),
                      ),
                  ],
                )
              : StatusCard(
                  notification.status!,
                  padding: EdgeInsets.zero,
                ),
        ),
      ],
    );
  }
}

class _NotificationAccount extends StatelessWidget {
  final NotificationEntity notification;
  const _NotificationAccount(this.notification);

  AccountEntity get account => notification.account!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Routes.profile, arguments: {'accountId': account.id});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountAvatar(
            avatar: account.avatar,
          ),
          const SizedBox(
            height: 5,
          ),
          // Row(children: [
          //   Text(
          //       account.displayName,
          //       style: const TextStyle(fontWeight: FontWeight.bold),),
          //       Text(' '),
          //       Text(notificationTypeText)
          // ],),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: account.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' '),
              TextSpan(text: notificationTypeText)
            ]),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  String get notificationTypeText {
    switch (notification.type) {
      case 'mention':
        return 'Mentioned you';
      case 'status':
        return '';
      case 'reblog':
        return 'boosted your post';
      case 'follow':
        return 'followed you';
      case 'follow_request':
        return 'Follow Request';
      case 'favourite':
        return 'favourited your status';
      case 'poll':
        return 'poll';
      case 'update':
        return 'update';
      case 'admin.sign_up':
        return 'admin.sign_up';
      case 'admin.report':
        return 'admin.report';
      default:
        return 'Some notification';
    }
  }
}

class _NotificationStatus extends StatelessWidget {
  final NotificationEntity notification;
  const _NotificationStatus(this.notification);

  StatusEntity get status => notification.status!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Routes.thread, arguments: {'statusId': status.id});
      },
      child: Html(
        style: {
          'a': Style(
            color: Theme.of(context).disabledColor,
            textDecoration: TextDecoration.none,
          ),
          'body': Style(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            color: Theme.of(context).disabledColor,
          ),
          'p': Style(margin: EdgeInsets.zero),
        },
        data: status.content,
      ),
    );
  }
}

class _NotificationDate extends StatelessWidget {
  final NotificationEntity notification;
  final DateFormat formatter = DateFormat.yMMMd();
  _NotificationDate(this.notification);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        Icons.watch_later_outlined,
        size: 12,
        color: theme.hintColor,
      ),
      const SizedBox(
        width: 2,
      ),
      Text(
        formatter.format(notification.createdAt),
        style: theme.textTheme.labelSmall!.copyWith(color: theme.hintColor),
      ),
    ]);
  }
}
