import 'package:flutter/material.dart';
import 'package:health_spike/steps/widgets/steps_panel_widget.dart';

class StepsPageBody extends StatelessWidget {

  const StepsPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: const [StepsPanelView()],
    );
  }
}