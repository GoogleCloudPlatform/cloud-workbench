import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  String title;
  DefaultPage({required this.title});

  @override
  Widget build(BuildContext context) {
    title = title.split(".")[1];
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Divider(),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
