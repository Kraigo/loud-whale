import 'package:flutter/material.dart';
import 'package:mastodon/base/routes.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  _onLogout() {
    Navigator.of(context).pushNamed(Routes.logout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _onLogout, child: Text("Logout")),
        ],
      ),
    );
  }
}
