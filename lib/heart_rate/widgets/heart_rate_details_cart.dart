import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_events.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_states.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:health_spike/utils/charts_utils.dart';

class HeartRateDetailsChartView extends StatefulWidget {
  
  const HeartRateDetailsChartView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeartRateDetailsChartViewState();

}

class _HeartRateDetailsChartViewState extends State<HeartRateDetailsChartView> {

  Timer? dataUpdaterTimer;

  @override
  void initState() {
    super.initState();
    dataUpdaterTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) => updateData());
    updateData();
  }

  @override
  void dispose() {
    dataUpdaterTimer?.cancel();
    super.dispose();
  }

  void updateData() {
    BlocProvider.of<HeartRateBloc>(context).add(GetAllHeartRateMeasurements());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 18),
      child: Container(
          decoration: BoxDecoration(
            color: HealthSpikeTheme.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(68.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: HealthSpikeTheme.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 18, top: 6),
                child: Text(
                  'Heart Rate Evolution',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: HealthSpikeTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.1,
                      color: HealthSpikeTheme.darkText),
                ),
              ),
              BlocBuilder<HeartRateBloc, HeartRateState>(
                  buildWhen: (previousState, state) {
                return state.heartRateStatus ==
                        HeartRateStatus.allValuesLoaded ||
                    state.heartRateStatus == HeartRateStatus.initial;
              }, builder: (context, state) {
                if (state.allHeartRates != null) {
                  return SizedBox(
                    child: LineChart(
                        id: 'Chart1',
                        chartColor: HealthSpikeTheme.redWhitened,
                        dataSamples: state.allHeartRates!),
                    height: 200,
                  );
                } else {
                  return SizedBox(
                    child: LineChart(
                        id: 'Chart1',
                        chartColor: HealthSpikeTheme.redWhitened,
                        dataSamples: SplayTreeMap()),
                    height: 200,
                  );
                }
              }),
            ]),
          )),
    );
  }
}
