import 'package:flutter/material.dart';

enum HomeMenu {
  home('Home', Icons.home_outlined, Icons.home),
  notifications(
      'Notifications', Icons.notifications_outlined, Icons.notifications),
  search('Search', Icons.search_outlined, Icons.search),
  profile('Profile', Icons.person_outline, Icons.person),
  compose('Compose', Icons.create_outlined, Icons.create);

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const HomeMenu(this.label, this.icon, this.selectedIcon);
}

class HomeProvider extends ChangeNotifier {
  List<HomeMenu> menuList = [
    HomeMenu.home,
    HomeMenu.notifications,
    HomeMenu.search,
    HomeMenu.profile,
    HomeMenu.compose,
  ];
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  HomeMenu get selectedMenu => menuList[_selectedIndex];

  selectMenu(HomeMenu menu) {
    _selectedIndex = menuList.indexOf(menu);
    notifyListeners();
  }

  selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
