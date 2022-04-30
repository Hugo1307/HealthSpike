import 'package:flutter/material.dart';
import 'package:health_spike/heart_rate/widgets/heart_rate_details_cart.dart';
import 'package:health_spike/heart_rate/widgets/heart_rate_panel.dart';

class HeartPageBody extends StatelessWidget {
  final int count = 9;

  const HeartPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: const [HeartRateDetailsChartView(), HeartRateView()],
    );
  }
}
