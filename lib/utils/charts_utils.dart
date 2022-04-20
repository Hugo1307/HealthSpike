import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChartSeries {
  final DateTime timestamp;
  final double value;

  LineChartSeries(this.timestamp, this.value);
}

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

  _convertDataSamples() {

    List<LineChartSeries> data = [];

    dataSamples.forEach((key, value) => data.add(LineChartSeries(key, value)));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    List<LineChartSeries> data = _convertDataSamples();

    List<charts.Series<LineChartSeries, int>> series = [
      charts.Series(
          id: id,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(chartColor),
          data: data,
          domainFn: (LineChartSeries series, _) => data.last.timestamp.millisecondsSinceEpoch - series.timestamp.millisecondsSinceEpoch ,
          measureFn: (LineChartSeries series, _) => series.value)
    ];

    return charts.LineChart(
      series,
      animate: true,
      domainAxis: const charts.NumericAxisSpec(
          showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
      primaryMeasureAxis: const charts.NumericAxisSpec(tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false))  
    );
  }
}
