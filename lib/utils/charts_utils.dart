import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChart extends StatelessWidget {

  final String id;
  final Color chartColor;
  final SplayTreeMap<DateTime, double> dataSamples;

  const LineChart(
      {Key? key,
      required this.id,
      required this.chartColor,
      required this.dataSamples})
      : super(key: key);

  List<TimeChartSeries> _convertDataSamples() {
    List<TimeChartSeries> data = [];
    dataSamples.forEach((key, value) => data.add(TimeChartSeries(key, value)));
    return data;
  }

  List<charts.Series<TimeChartSeries, DateTime>> _createDataSamples() =>
    [charts.Series<TimeChartSeries, DateTime>(
        id: id,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(chartColor),
        domainFn: (TimeChartSeries series, _) => series.timestamp,
        measureFn: (TimeChartSeries series, _) => series.value,
        data: _convertDataSamples(),
      )];
  

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createDataSamples(),
      animate: true,
      primaryMeasureAxis: const charts.NumericAxisSpec(tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false)),
      domainAxis: const charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        minute: charts.TimeFormatterSpec(
          format: 'HH:mm',
          transitionFormat: 'HH:mm',
        ),
      )),
    );
  }

}

class TimeChartSeries {
  final DateTime timestamp;
  final double value;

  TimeChartSeries(this.timestamp, this.value);
}