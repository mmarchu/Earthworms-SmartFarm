import 'package:earthworms/HomeandData/BarGraph/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatelessWidget {
  final List monthSummary;
  const MyBarGraph({super.key, required this.monthSummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        ratAmount: monthSummary[0],
        toadAmount: monthSummary[1],
        skinkAmount: monthSummary[2]);
    myBarData.initalizeBarData();

    return BarChart(BarChartData(
      maxY: 50,
      minY: 0,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: true),
      titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles))),
      barGroups: myBarData.barData
          .map(
            (data) => BarChartGroupData(x: data.x, barRods: [
              BarChartRodData(
                  toY: data.y,
                  color: Color.fromRGBO(42, 62, 54, 1),
                  width: 35,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 50,
                      color: Color.fromRGBO(42, 62, 54, 0.358))),
            ]),
          )
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Rat', style: style);
      break;
    case 1:
      text = const Text('Toad', style: style);
      break;
    case 2:
      text = const Text('Skink', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
