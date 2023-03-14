import 'package:flutter/material.dart';
import 'package:mastodon/providers/home_provider.dart';
import 'package:mastodon/screens/compose_screen.dart';
import 'package:mastodon/screens/my_profile_screen.dart';
import 'package:mastodon/screens/notifications_screen.dart';
import 'package:mastodon/screens/search_screen.dart';
import 'package:mastodon/screens/preferences_screen.dart';
import 'package:mastodon/screens/timeline_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _Sidebar(),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _MainContent()),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  _onCompose(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComposeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return NavigationRail(
      extended: false,
      leading: FloatingActionButton(
        onPressed: () {_onCompose(context);},
        elevation: 0,
        child: const Icon(Icons.edit),
      ),
      groupAlignment: 0,
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
      labelType: NavigationRailLabelType.selected,
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
        return const SearchScreen();
      case HomeMenu.preferences:
        return const PreferencesScreen();
      default:
        return const Center(child: Text("Empty Screen"));
    }
  }
}
