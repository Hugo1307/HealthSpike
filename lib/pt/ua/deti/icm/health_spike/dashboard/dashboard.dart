import 'package:flutter/material.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/dashboard/heart_rate_panel.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/dashboard/horizontal_list_view.dart';

import 'main_panel.dart';

class DashboardBody extends StatelessWidget {
  final int count = 9;

  const DashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [OverviewPanelView(), HeartRateView(), WeatherListView()],
    );
  }
}
