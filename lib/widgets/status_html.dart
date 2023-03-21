import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StatusHTML extends StatelessWidget {
  final String? data;
  const StatusHTML({this.data, super.key});

  _openLink(String url) async {
    try {
      await launchUrlString(url);
    } catch (_) {}
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
      onLinkTap: (url, context, attributes, element) {
        debugPrint(url);
        if (url != null) {
          _openLink(url);
        }
      },
    );
  }
}
