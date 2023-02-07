import 'package:flutter/material.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/providers/thread_provider.dart';
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
    originalStatusKey = GlobalKey();
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    await context.read<ThreadProvider>().loadThread(widget.statusId);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Scrollable.ensureVisible(originalStatusKey.currentContext!));
  }

  @override
  Widget build(BuildContext context) {
    final threadProvider = context.watch<ThreadProvider>();
    return Scaffold(
        appBar: AppBar(title: const Text('Thread')),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final status = threadProvider.ancestors[index];
                  return MiddleContainer(StatusCard(status));
                },
                childCount: threadProvider.ancestors.length,
              ),
            ),
            SliverToBoxAdapter(
                key: originalStatusKey,
                child: threadProvider.threadStatus != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withOpacity(0.03),
                        ),
                        child: MiddleContainer(
                          StatusCard(threadProvider.threadStatus!),
                        ),
                      )
                    : const Text("Not data")),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final status = threadProvider.descendants[index];
                  return MiddleContainer(StatusCard(status));
                },
                childCount: threadProvider.descendants.length,
              ),
            ),
          ],
        ));
  }
}

class _ThreadCard extends StatelessWidget {
  final StatusEntity? status;
  const _ThreadCard(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("status"),
    );
  }
}
