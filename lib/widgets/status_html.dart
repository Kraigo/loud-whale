import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/providers/home_provider.dart';
import 'package:mastodon/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusHTML extends StatelessWidget {
  final String? data;
  const StatusHTML({this.data, super.key});

  _openLink(String url) async {
    try {
      await launchUrlString(url);
    } catch (_) {}
  }

  _openSearch(BuildContext context, String text) {
    context.read<HomeProvider>().selectMenu(HomeMenu.search);
    context.read<SearchProvider>().selectSearch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        'body': Style(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
        ),
        'p': Style(
          margin: const EdgeInsets.all(0),
        ),
        'p:not(:last-child)': Style(
          margin: const EdgeInsets.only(bottom: 6),
        ),
        'a': Style(
          textDecoration: TextDecoration.none,
        )
      },
      onLinkTap: (url, readContext, attributes, element) {
        if (element != null) {
          if (element!.className.contains('hashtag')) {
            final text = element.innerHtml.replaceAll(RegExp(r'<[^>]+>'), '');
            _openSearch(context, text);
            return;
          }
        }
        if (url != null) {
          _openLink(url);
          return;
        }
      },
    );
  }
}
