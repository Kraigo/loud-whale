import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:mastodon/providers/timeline_provider.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late ScrollController _scrollController;
  late StreamSubscription _updateSubscription;
  late Timer _refreshTimer;

  @override
  void initState() {
    Future.microtask(_loadInitial);
    _scrollController = ScrollController();
    final timelineProvider = context.read<TimelineProvider>();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const delta = 100;
      if (maxScroll - currentScroll <= delta) {
        _onLoadMore();
      }
    });

    _updateSubscription = context.read<AppDatabase>().changes.listen((event) {
      timelineProvider.refresh();
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _backgroundRefresh();
      debugPrint("Timer refresh");
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _updateSubscription.cancel();
    _refreshTimer.cancel();
    super.dispose();
  }

  _onLoadMore() async {
    final timelineProvider = context.read<TimelineProvider>();
    timelineProvider.loadTimelineMore();
  }

  _loadInitial() async {
    final timelineProvider = context.read<TimelineProvider>();
    await timelineProvider.refresh();
    await timelineProvider.loadTimeline();
    await timelineProvider.refresh();
  }

  Future<void> _pullRefresh() async {
    final timelineProvider = context.read<TimelineProvider>();
    await timelineProvider.loadTimelineRefresh();
    await timelineProvider.refresh();
  }

  Future<void> _backgroundRefresh() async {
    final timelineProvider = context.read<TimelineProvider>();
    await timelineProvider.loadTimelineRefresh(updateLatest: false);
    await timelineProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: _TimelineLoading(),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _pullRefresh,
            child: _TimelineList(
              controller: _scrollController,
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: _ScrollTopButton(
                  controller: _scrollController,
                ),
              )),
        ],
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  final ScrollController? controller;
  const _TimelineList({this.controller});

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();
    final statuses = timelineProvider.statuses;
    return ListView.separated(
      controller: controller,
      itemBuilder: (context, index) {
        final item = statuses[index];

        return MiddleContainer(StatusCard(
          item,
          collapsed: true,
          showActionHeader: true,
        ));
      },
      separatorBuilder: ((context, index) => const MiddleContainer(Divider())),
      itemCount: statuses.length,
    );
  }
}

class _TimelineLoading extends StatelessWidget {
  const _TimelineLoading();

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();
    if (timelineProvider.loading) {
      return const SizedBox(height: 1, child: LinearProgressIndicator());
    }
    return Container();
  }
}

class _ScrollTopButton extends StatelessWidget {
  final ScrollController controller;
  const _ScrollTopButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final timelineProvider = context.watch<TimelineProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      child: timelineProvider.hasNewStatuses
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("Scroll to newest"),
                onPressed: () async {
                  timelineProvider.updateLatestStatusId(null);
                  await timelineProvider.refresh();
                  controller.jumpTo(0);
                },
              ),
            )
          : Container(),
    );
  }
}
