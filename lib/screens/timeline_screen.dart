import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/status_card.dart';
import 'package:provider/provider.dart';

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
    context.read<TimelineProvider>().loadTimeline();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: _TimelineList(),
        ),
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
        return StatusCard(item);
      },
      separatorBuilder: ((context, index) {
        return Divider();
      }),
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
