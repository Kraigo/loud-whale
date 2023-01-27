import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatelessWidget {
  final Status status;
  const StatusCard(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        _StatusCardAuthor(status),
        Text(status.content),
        _StatusCardActions()
      ]),
    );
  }
}

class _StatusCardAuthor extends StatelessWidget {
  final Status status;
  const _StatusCardAuthor(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            context.read<TimelineProvider>().getAccountById(status.accountId),
        builder: (context, snapshot) {
          var displayName = 'User';

          if (snapshot.data?.display_name.isNotEmpty ?? false) {
            displayName = snapshot.data!.display_name;
          }
          if (snapshot.data?.display_name.isEmpty ?? false) {
            displayName = snapshot.data!.username;
          }

          return Row(children: [
                Text(displayName)
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
