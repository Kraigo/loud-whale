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
    return StreamBuilder<List<StatusEntity>>(
        initialData: const [],
        stream: context.read<AppDatabase>().statusDao.findAllStatuses(),
        builder: (context, snapshot) {
          final statuses = snapshot.data!;
          return ListView.separated(
            // shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = statuses[index];

              if (item.reblogId != null) {
                return StatusCardContainer(StatusCardStream(
                  statusId: item.reblogId!,
                  reblog: item,
                ));
              }

              return StatusCardContainer(StatusCard(item));
            },
            separatorBuilder: ((context, index) {
              return Divider();
            }),
            itemCount: statuses.length,
          );
        });
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
