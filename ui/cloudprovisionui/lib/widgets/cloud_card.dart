import 'package:flutter/material.dart';

class CloudCard extends StatelessWidget {
  final Widget child;
  const CloudCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: child,
    );
  }
}
