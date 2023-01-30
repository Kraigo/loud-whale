import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/providers/timeline_provider.dart';
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
    context.read<TimelineProvider>().loadTimeline();
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
                      return _ThreadCard(status);
                    })),
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
