import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final prices;

  LineChartWidget({this.prices});

  final List<Color> gradientsColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d9a),
  ];

  @override
  Widget build(BuildContext context) {
    //prices are Strings -> first convert them into an array of integers
    List intPrices = [];
    for (var i = 0; i < prices.length; i++) {
      intPrices.add((int.parse(prices[i])) / 1000000000000000000);
    }
    // now create a list of spots to display the prices
    List<FlSpot> spots = intPrices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
    return LineChart(
      LineChartData(
          axisTitleData: FlAxisTitleData(
            leftTitle: AxisTitle(
                showTitle: true,
                titleText: "Prices in Eth",
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).highlightColor)),
            bottomTitle: AxisTitle(
                showTitle: true,
                titleText: "Selling Events",
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).highlightColor)),
          ),
          lineBarsData: [
            LineChartBarData(spots: spots),
          ]),
    );
  }
}
