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

    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          icon,
          if (label?.isNotEmpty ?? false) ...[
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Text(
                key: ValueKey(label),
                label!,
                style: theme.textTheme.labelSmall,
              ),
            )
          ]
        ]),
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
