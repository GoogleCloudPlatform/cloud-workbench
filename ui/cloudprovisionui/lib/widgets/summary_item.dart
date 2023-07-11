import 'package:flutter/material.dart';

import '../utils/styles.dart';

class SummaryItem extends StatelessWidget {
  final Widget child;
  final String label;

  const SummaryItem({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: SelectableText(
            '$label:',
            style: AppText.fontStyleBold,
          ),
        ),
        child,
        const SizedBox(height: 4),
      ],
    );
  }
}
