import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mastodon/providers/search_providers.dart';
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
    _tabController = TabController(vsync: this, length: tabs.length);
    _textController = TextEditingController();

    _textController.addListener(() {
      final text = _textController.text;
      if (_textDebounce?.isActive ?? false) _textDebounce?.cancel();
      if (text.isEmpty) return;
      _textDebounce = Timer(const Duration(milliseconds: 500), () {
        _onSearchInput(text);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _textDebounce?.cancel();
    super.dispose();
  }

  _onSearchInput(String text) async {
    final searchProvider = context.read<SearchProvider>();
    await searchProvider.loadSearch(text);
    await searchProvider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Search for something',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SearchStatusesList(),
          _SearchAccountsList(),
          Text('Hashtables will be soon')
        ],
      ),
    );
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
  const _SearchStatusesList({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final items = searchProvider.statuses;
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return Text("item ${item.id}");
      },
      itemCount: items.length,
    );
  }
}
