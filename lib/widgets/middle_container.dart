import 'package:flutter/material.dart';

class MiddleContainer extends StatelessWidget {
  final Widget child;
  const MiddleContainer(this.child, {super.key});
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
