import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  final String? avatar;
  const AccountAvatar({required this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return AccountAvatarPlaceholder(
      child: avatar != null ? Image.network(avatar!) : null,
    );
  }
}

class AccountAvatarPlaceholder extends StatelessWidget {
  final Widget? child;
  const AccountAvatarPlaceholder({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).disabledColor),
            child: child,
          ),
        ));
  }
}
