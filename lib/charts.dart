import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'dart:math';

class PointsPerWeekGraph extends StatelessWidget {
  final List<RosterLeague> filteredRosters;

  const PointsPerWeekGraph({required this.filteredRosters, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                    gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            child: Text(
                              'W${value.toInt()}',
                              style: TextStyle(fontSize: 12),
                            ),
                            meta: meta,
                          );
                        },
                      )),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          minIncluded: false,
                          maxIncluded: false,
                          showTitles: true,
                          interval: 10,
                          reservedSize: 50,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: const Color(0xff37434d))),
                    minX: 1,
                    maxX: getMaxWeek(),
                    minY: getMinPoints(),
                    maxY: getMaxPoints(),
                    lineBarsData: getLineBarsData()),
              ),
            ),
          ),
        ),
        buildLegend(),
      ],
    );
  }

  List<LineChartBarData> getLineBarsData() {
    List<LineChartBarData> lines = [];

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.amber,
      Colors.pink,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
      Colors.cyan,
      Colors.lightGreen,
      Colors.lightBlue,
      Colors.deepOrange,
      Colors.black,
      Colors.blueGrey,
      Colors.cyanAccent,
      Colors.deepPurpleAccent
    ];

    // Create a line for each roster
    for (int i = 0; i < filteredRosters.length; i++) {
      final roster = filteredRosters[i];
      final color = colors[i];

      List<FlSpot> spots = [];
      double week = 1;
      for (var truePoint in roster.truePoints) {
        if (truePoint == 0.0) {
          continue;
        } else {
          spots.add(FlSpot(week, truePoint));
        }
        week += 1;
      }

      // Sort spots by week number
      spots.sort((a, b) => a.x.compareTo(b.x));

      // Add this roster's line to the chart
      lines.add(LineChartBarData(
          color: color,
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: spots));
    }

    return lines;
  }

  double getMaxWeek() {
    double maxWeek = filteredRosters.first.truePoints.length.toDouble();
    return maxWeek;
  }

  double getMaxPoints() {
    double maxPoints = 0;

    for (final roster in filteredRosters) {
      final maxInRoster =
          roster.truePoints.isNotEmpty ? roster.truePoints.reduce(max) : 0.0;
      maxPoints = max(maxPoints, maxInRoster);
    }

    return maxPoints;
  }

  double getMinPoints() {
    double minPoints = double.infinity;

    for (final roster in filteredRosters) {
      // Filter out zeros and empty lists
      final nonZeroPoints =
          roster.truePoints.where((point) => point > 0).toList();

      if (nonZeroPoints.isNotEmpty) {
        final currentMin = nonZeroPoints.reduce(min);
        minPoints = min(minPoints, currentMin);
      }
    }

    minPoints = max(minPoints - 5, 0);
    return minPoints;
  }

  // Build a legend widget showing roster names and their corresponding colors
  Widget buildLegend() {
    // Array of colors for different lines - same as in getLineBarsData
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.amber,
      Colors.pink,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
      Colors.cyan,
      Colors.lightGreen,
      Colors.lightBlue,
      Colors.deepOrange,
      Colors.black,
      Colors.blueGrey,
      Colors.cyanAccent,
      Colors.deepPurpleAccent
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Wrap(
          direction: Axis.vertical,
          spacing: 12.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: List.generate(
            filteredRosters.length,
            (index) {
              final color = colors[index % colors.length];
              final roster = filteredRosters[index];

              // Get roster name - adjust this based on your data structure
              final rosterName = roster.displayName ?? 'Roster ${index + 1}';

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    rosterName,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
