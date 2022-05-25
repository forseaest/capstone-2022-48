import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompareStatDiet extends StatefulWidget {
  const CompareStatDiet({Key? key}) : super(key: key);

  @override
  State<CompareStatDiet> createState() => _CompareStatDietState();
}

class _CompareStatDietState extends State<CompareStatDiet> {
  @override
  Widget build(BuildContext context) {
    final Color leftBarColor = const Color(0xff53fdd7);
    final Color rightBarColor = const Color(0xffff5182);
    final double width = 7;

    late List<BarChartGroupData> rawBarGroups;
    late List<BarChartGroupData> showingBarGroups;

    int touchedGroupIndex = -1;

    BarChartGroupData makeGroupData(int x, double y1, double y2) {
      return BarChartGroupData(barsSpace: 4, x: x, barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ]);
    }

    final barGroup1 = makeGroupData(0, 5, 6);
    final barGroup2 = makeGroupData(1, 6, 6);
    final barGroup3 = makeGroupData(2, 8, 5);
    final barGroup4 = makeGroupData(3, 10, 6);
    final barGroup5 = makeGroupData(4, 1, 6);
    final barGroup6 = makeGroupData(5, 9, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    Widget leftTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      Widget text;
      if (value == 0) {
        text = Text('1k');
      } else if (value == 10) {
        text = Text('5k');
      } else if (value == 19) {
        text = Text('10k');
      } else {
        return Text('');
      }
      return text;
    }

    Widget bottomTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      Widget text;
      switch (value.toInt()) {
        case 0:
          text = const Text(
            'Mn',
            style: style,
          );
          break;
        case 1:
          text = const Text(
            'Te',
            style: style,
          );
          break;
        case 2:
          text = const Text(
            'Wd',
            style: style,
          );
          break;
        case 3:
          text = const Text(
            'Tu',
            style: style,
          );
          break;
        case 4:
          text = const Text(
            'Fr',
            style: style,
          );
          break;
        case 5:
          text = const Text(
            'St',
            style: style,
          );
          break;
        case 6:
          text = const Text(
            'Sn',
            style: style,
          );
          break;
        default:
          text = const Text(
            '',
            style: style,
          );
          break;
      }
      return text;
    }

    Widget makeTransactionsIcon() {
      const width = 4.5;
      const space = 3.5;
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width,
            height: 10,
            color: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 28,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 42,
            color: Colors.white.withOpacity(1),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 28,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(
            width: space,
          ),
          Container(
            width: width,
            height: 10,
            color: Colors.white.withOpacity(0.4),
          ),
        ],
      );
    }

    Widget getBarChart() {
      return BarChart(
        BarChartData(
          maxY: 20,
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.grey,
                getTooltipItem: (_a, _b, _c, _d) => null,
              ),
              touchCallback: (FlTouchEvent event, response) {
                if (response == null || response.spot == null) {
                  setState(() {
                    touchedGroupIndex = -1;
                    showingBarGroups = List.of(rawBarGroups);
                  });
                  return;
                }

                touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                setState(() {
                  if (!event.isInterestedForInteractions) {
                    touchedGroupIndex = -1;
                    showingBarGroups = List.of(rawBarGroups);
                    return;
                  }
                  showingBarGroups = List.of(rawBarGroups);
                  if (touchedGroupIndex != -1) {
                    var sum = 0.0;
                    for (var rod
                        in showingBarGroups[touchedGroupIndex].barRods) {
                      sum += rod.toY;
                    }
                    final avg = sum /
                        showingBarGroups[touchedGroupIndex].barRods.length;

                    showingBarGroups[touchedGroupIndex] =
                        showingBarGroups[touchedGroupIndex].copyWith(
                      barRods: showingBarGroups[touchedGroupIndex]
                          .barRods
                          .map((rod) {
                        return rod.copyWith(toY: avg);
                      }).toList(),
                    );
                  }
                });
              }),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 42,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: leftTitles,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingBarGroups,
          gridData: FlGridData(show: false),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 30.0,
        ),
        child: getBarChart(),
      ),
    );
  }
}
