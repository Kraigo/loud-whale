import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ThreadScreen extends StatefulWidget {
  final String statusId;
  const ThreadScreen({required this.statusId, super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  @override
  void initState() {
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    context.read<TimelineProvider>().loadThread(widget.statusId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Thread')),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: StreamBuilder(
                    stream: context
                        .read<AppDatabase>()
                        .statusDao
                        .findStatusById(widget.statusId),
                    builder: (context, snapshot) {
                      final status = snapshot.data;
                      if (status != null) {
                      return StatusCardContainer(StatusCard(status));

                      }
                      return Text("no data");
                    })),
            StreamBuilder(
                stream: context
                    .read<AppDatabase>()
                    .statusDao
                    .findStatusReplies(widget.statusId),
                initialData: [],
                builder: (context, snapshot) {
                  final statuses = snapshot.data!;

                  return SliverList(delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final status = statuses![index];
                      if (status != null) {
                      return StatusCardContainer(StatusCard(status!));

                      }
                      return Text("no data");
                    }, childCount: statuses.length
                  ));
                })
          ],
        ));
  }
}

class _ThreadCard extends StatelessWidget {
  final StatusEntity? status;
  const _ThreadCard(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("status"),
    );
  }
}
