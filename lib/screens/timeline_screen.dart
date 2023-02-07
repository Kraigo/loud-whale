import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:mastodon/providers/timeline_provider.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    await context.read<TimelineProvider>().refresh();
    await context.read<TimelineProvider>().loadTimeline();
  }

  Future<void> _pullRefresh() async {
    await context.read<TimelineProvider>().loadTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: _TimelineLoading(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: _TimelineList(),
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({super.key});

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();
    final statuses = timelineProvider.statuses;
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = statuses[index];

        if (item.reblog != null) {
          return MiddleContainer(StatusCard(
            item.reblog!,
            reblog: item,
          ));
        }

        return MiddleContainer(StatusCard(item));
      },
      separatorBuilder: ((context, index) => const Divider()),
      itemCount: statuses.length,
    );
  }
}

class _TimelineLoading extends StatelessWidget {
  const _TimelineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();
    if (timelineProvider.loading) {
      return LinearProgressIndicator();
    }
    return Container();
  }
}
