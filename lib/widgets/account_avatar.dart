import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  final String? avatar;
  const AccountAvatar({required this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: 48,
        height: 48,
        child: avatar != null ? Image.network(avatar!) : const Text(":)"),
      ),
    );
  }
}
