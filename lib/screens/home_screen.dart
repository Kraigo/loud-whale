import 'package:flutter/material.dart';
import 'package:mastodon/providers/home_provider.dart';
import 'package:mastodon/screens/compose_screen.dart';
import 'package:mastodon/screens/my_profile_screen.dart';
import 'package:mastodon/screens/notifications_screen.dart';
import 'package:mastodon/screens/timeline_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _Sidebar(),
        Expanded(child: _MainContent()),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return NavigationRail(
      destinations: [
        ...homeProvider.menuList.map(
          (e) => NavigationRailDestination(
            icon: Icon(e.icon),
            selectedIcon: Icon(e.selectedIcon),
            label: Text(e.label),
          ),
        )
      ],
      onDestinationSelected: (value) {
        homeProvider.selectIndex(value);
      },
      selectedIndex: homeProvider.selectedIndex,
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    switch (homeProvider.selectedMenu) {
      case HomeMenu.home:
        return const TimelineScreen();
      case HomeMenu.notifications:
        return const NotificationsScreen();
      case HomeMenu.profile:
        return const MyProfileScreen();
      case HomeMenu.compose:
        return const ComposeScreen();
      case HomeMenu.search:
        return const ComposeScreen();
      default:
        return const Center(child: Text("Empty Screen"));
    }
  }
}
