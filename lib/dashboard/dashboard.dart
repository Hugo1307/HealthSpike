import 'package:flutter/material.dart';
import 'package:health_spike/heart_rate/widgets/heart_rate_panel.dart';
import 'package:health_spike/dashboard/horizontal_list_view.dart';

import 'main_panel.dart';

class DashboardBody extends StatelessWidget {
  final int count = 9;

  const DashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: const [OverviewPanelView(), HeartRateView(), WeatherListView()],
    );
  }
}
