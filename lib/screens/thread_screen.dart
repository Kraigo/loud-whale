import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/providers/thread_provider.dart';
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
  late GlobalKey originalStatusKey;

  @override
  void initState() {
    originalStatusKey = new GlobalKey();
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    await context.read<ThreadProvider>().loadThread(widget.statusId);
    Scrollable.ensureVisible(originalStatusKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Thread')),
        body: CustomScrollView(
          slivers: [
            Consumer<ThreadProvider>(
              builder: (context, value, child) {
                final statuses = value.ancestors;
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  final status = statuses[index];
                  return MiddleContainer(StatusCard(status));
                }, childCount: statuses.length));
              },
            ),
            SliverToBoxAdapter(
                key: originalStatusKey,
                child:
                    Consumer<ThreadProvider>(builder: (context, value, child) {
                  final status = value.threadStatus;
                  if (status != null) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.03),
                        ),
                        child: MiddleContainer(StatusCard(status)));
                  }
                  return Text("no data");
                })),
            Consumer<ThreadProvider>(
              builder: (context, value, child) {
                final statuses = value.descendants;
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  final status = statuses[index];
                  return MiddleContainer(StatusCard(status));
                }, childCount: statuses.length));
              },
            ),
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
