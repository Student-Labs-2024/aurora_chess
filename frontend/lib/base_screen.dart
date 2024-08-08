import "package:flutter/material.dart";

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.background,
      body: child,
    );
  }
}
