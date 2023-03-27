import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mastodon/models/search_type.dart';
import 'package:mastodon/providers/search_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _textController;
  late ScrollController _scrollController;
  Timer? _textDebounce;
  Set<int> selected = {1};

  static const List<Tab> tabs = [
    Tab(text: 'Statuses'),
    Tab(text: 'Accounts'),
    Tab(text: 'Hashtags'),
  ];

  @override
  void initState() {
    super.initState();
    final searchProvider = context.read<SearchProvider>();
    _tabController = TabController(vsync: this, length: tabs.length);
    _textController = TextEditingController();
    _scrollController = ScrollController();

    _textController.addListener(() {
      final text = _textController.text;
      if (_textDebounce?.isActive ?? false) _textDebounce?.cancel();
      if (text.isEmpty) return;
      _textDebounce = Timer(const Duration(milliseconds: 500), () {
        _scrollController.jumpTo(0);
        _onSearchInput(text);
      });
    });

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      const delta = 100;
      if (maxScroll - currentScroll <= delta) {
        _onLoadMore();
      }
    });

    _textController.text = searchProvider.searchText;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _textDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  _onSearchInput(String text) async {
    final searchProvider = context.read<SearchProvider>();
    searchProvider.selectSearch(text);

    if (searchProvider.searchType == SearchType.all) {
      await searchProvider.loadSearch();
    } else {
      await searchProvider.loadSearchTimeline();
    }
    await searchProvider.refresh();
  }

  _onLoadMore() async {
    final searchProvider = context.read<SearchProvider>();
    if (searchProvider.loading) return;
    await searchProvider.loadSearchTimelineMore();
    await searchProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Search for something',
            prefixIcon: Icon(_searchTypeIcon),
          ),
        ),
        bottom: searchProvider.searchType == SearchType.all
            ? TabBar(
                controller: _tabController,
                tabs: tabs,
              )
            : const PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: _SearchLoading(),
              ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SearchStatusesList(controller: _scrollController),
          _SearchAccountsList(),
          Text('Hashtables will be soon')
        ],
      ),
    );
  }

  IconData get _searchTypeIcon {
    final searchProvider = context.read<SearchProvider>();

    switch (searchProvider.searchType) {
      case SearchType.hashtags:
        return Icons.tag;
      case SearchType.accounts:
        return Icons.alternate_email;
      default:
        return Icons.search;
    }
  }
}

class _SearchAccountsList extends StatelessWidget {
  const _SearchAccountsList({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final items = searchProvider.accounts;
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return Row(
          children: [
            AccountAvatar(avatar: item.avatar),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.displayName),
                Text('@${item.username}'),
              ],
            )
          ],
        );
      },
      itemCount: items.length,
    );
  }
}

class _SearchStatusesList extends StatelessWidget {
  final ScrollController? controller;
  const _SearchStatusesList({this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final items = searchProvider.statuses;
    return ListView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return MiddleContainer(StatusCard(item));
      },
      itemCount: items.length,
    );
  }
}

class _SearchLoading extends StatelessWidget {
  const _SearchLoading();

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    if (searchProvider.loading) {
      return const SizedBox(height: 1, child: LinearProgressIndicator());
    }
    return Container();
  }
}
