import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final Widget title;
  const AppListTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: title,
        tileColor: Colors.grey[200],
      ),
    );
  }
}
