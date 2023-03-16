import 'dart:async';

import 'package:flutter/material.dart';
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
  late Timer _refreshTimer;

  @override
  void initState() {
    Future.microtask(_loadInitial);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const delta = 100;
      if (maxScroll - currentScroll <= delta) {
        _onLoadMore();
      }
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final timelineProvider = context.read<TimelineProvider>();
      timelineProvider.refresh();
    });
    
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
  }

  Future<void> _pullRefresh() async {
    await context.read<TimelineProvider>().loadTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: _TimelineLoading(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: _TimelineList(controller: _scrollController),
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

        return MiddleContainer(StatusCard(item));
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
      return const LinearProgressIndicator();
    }
    return Container();
  }
}
