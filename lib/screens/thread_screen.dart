import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mastodon/base/constants.dart';
import 'package:mastodon/base/database.dart';
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
  late StreamSubscription _updateSubscription;

  @override
  void initState() {
    originalStatusKey = GlobalKey();
    final threadProvider = context.read<ThreadProvider>();

    Future.delayed(const Duration(milliseconds: 500))
        .then((_) => _loadInitial());

    _updateSubscription = context.read<AppDatabase>().changes.listen((event) {
      threadProvider.refresh(widget.statusId);
    });
    super.initState();
  }

  @override
  void deactivate() {
    final threadProvider = context.read<ThreadProvider>();
    threadProvider.clear();
    super.deactivate();
  }

  _loadInitial() async {
    final threadProvider = context.read<ThreadProvider>();
    await Future.any([
      threadProvider.loadStatus(widget.statusId),
      threadProvider.loadThread(widget.statusId)
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (originalStatusKey.currentContext != null) {
        Scrollable.ensureVisible(originalStatusKey.currentContext!);
      }
    });
  }

  @override
  void dispose() {
    _updateSubscription.cancel();
    super.dispose();
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
                  final isLast = threadProvider.ancestors.length - 1 == index;
                  return MiddleContainer(
                    isLast
                        ? StatusCard(status)
                        : DividerContainer(child: StatusCard(status)),
                  );
                },
                childCount: threadProvider.ancestors.length,
              ),
            ),
            SliverToBoxAdapter(
                key: originalStatusKey,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(Constants.cardBorderRadius),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(Constants.cardBorderRadius)),
                    child: MiddleContainer(threadProvider.threadStatus != null
                        ? StatusCard(threadProvider.threadStatus!,
                            disabledThread: true)
                        : const StatusCardPlaceholder()),
                  ),
                )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final status = threadProvider.descendants[index];
                  final isLast = threadProvider.descendants.length - 1 == index;
                  return MiddleContainer(
                    isLast
                        ? StatusCard(status)
                        : DividerContainer(child: StatusCard(status)),
                  );
                },
                childCount: threadProvider.descendants.length,
              ),
            ),
          ],
        ));
  }
}
