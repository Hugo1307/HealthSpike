import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final Widget child;

  const AppBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: child);
  }
}