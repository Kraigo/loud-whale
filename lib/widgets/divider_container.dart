import 'package:flutter/material.dart';

class DividerContainer extends StatelessWidget {
  final Widget child;
  const DividerContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [child, const Divider()],
    );
  }
}
