import 'package:flutter/material.dart';

class StatusCardContainer extends StatelessWidget {
  final Widget child;
  const StatusCardContainer(this.child, {super.key});
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Flexible(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      ),
    );
  }
}
