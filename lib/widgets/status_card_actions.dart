import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:provider/provider.dart';

import 'widgets.dart';

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

