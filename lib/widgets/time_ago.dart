import 'package:flutter/material.dart';

class TimeAgo extends StatelessWidget {
  final DateTime dateTime;
  const TimeAgo(this.dateTime, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.watch_later_outlined,
          size: 12,
          color: theme.hintColor,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          _format,
          style: theme.textTheme.caption,
        ),
      ],
    );
  }

  String get _format {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()}y";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()}m";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()}w";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays}d";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours}h";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m";
    }
    return "now";
  }
}
