import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isActivated;
  final Function() onPressed;
  const ActionButton({
    required this.icon,
    required this.onPressed,
    this.label,
    bool? isActivated,
    super.key,
  }) : isActivated = isActivated ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isActivated ? theme.primaryColor : theme.hintColor;
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
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
