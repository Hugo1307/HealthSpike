import 'package:flutter/material.dart';

import 'main_panel.dart';

class DashboardBody extends StatelessWidget {

  final int count = 9;

  const DashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        OverviewPanelView()
      ],
    );
  }
}