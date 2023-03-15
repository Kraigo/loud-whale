import 'package:flutter/material.dart';

class AccountAvatar extends StatelessWidget {
  final String? avatar;
  const AccountAvatar({required this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return AccountAvatarPlaceholder(
      size: 40,
      child: avatar != null ? Image.network(avatar!) : null,
    );
  }
}

class AccountAvatarReblogged extends StatelessWidget {
  final String? avatar;
  final String rebloggedAvatar;
  const AccountAvatarReblogged({
    required this.avatar,
    required this.rebloggedAvatar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(children: [
        AccountAvatarPlaceholder(
          size: 34,
          child: Image.network(avatar!),
        ),
        Positioned(
          right: 0,
          bottom: 0.0,
          child: AccountAvatarPlaceholder(
            size: 20,
            child: Image.network(rebloggedAvatar),
          ),
        )
      ]),
    );
  }
}

class AccountAvatarPlaceholder extends StatelessWidget {
  final Widget? child;
  final double? size;
  const AccountAvatarPlaceholder(
      {this.child, this.size = double.infinity, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: size,
          height: size,
          child: Container(
            // decoration: BoxDecoration(color: Theme.of(context).disabledColor),
            child: child,
          ),
        ));
  }

  get borderRadius => size != null ? size! * 0.3 : 10;
}
