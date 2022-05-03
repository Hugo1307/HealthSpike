import 'package:flutter/material.dart';
import 'package:health_spike/location/widgets/location_panel.dart';

class DistancePageBody extends StatelessWidget {
  final int count = 9;

  const DistancePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: const [LocationPanelView()],
    );
  }
}