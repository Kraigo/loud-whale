import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/widgets/widgets.dart';

class StatusCard extends StatelessWidget {
  final StatusEntity status;
  final StatusEntity? reblog;
  const StatusCard(this.status, {this.reblog, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        if (reblog != null) StatusCardReblogged(reblog!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusCardAuthor(status),
            TimeAgo(status.createdAt),
          ],
        ),
        Html(
            style: {
              'body': Style(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0))
            },
            data: status.content,
            onLinkTap: (url, context, attributes, element) {
              debugPrint(url);
            }),
        StatusCardMedia(status),
        const SizedBox(
          height: 10,
        ),
        StatusCardActions(status)
      ]),
    );
  }
}
