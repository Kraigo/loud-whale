import 'package:flutter/material.dart';

class StatusCardContainer extends StatelessWidget {
  final Widget child;
  const StatusCardContainer(this.child, {super.key});
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: LimitedBox(
        maxWidth: 600,
        child: child
      ),
    );
  }
}
