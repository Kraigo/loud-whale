import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final ActionIcon icon;
  final String? label;
  final Function()? onPressed;
  const ActionButton({
    required this.icon,
    this.onPressed,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                icon,
                if (label != null)
                  Text(
                    label!,
                    style: theme.textTheme.caption,
                  ),
              ],
            )),
      ),
    );
  }
}

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final bool isActivated;
  const ActionIcon({
    required this.icon,
    bool? isActivated,
    super.key,
  }) : isActivated = isActivated ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isActivated ? theme.primaryColor : theme.hintColor;
    return Icon(
      icon,
      size: 18,
      color: iconColor,
    );
  }
}
