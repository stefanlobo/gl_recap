import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'dart:math';

class PointsPerWeekGraph extends StatefulWidget {
  final List<RosterLeague> filteredRosters;

  const PointsPerWeekGraph({
    Key? key,
    required this.filteredRosters,
  }) : super(key: key);

  @override
  State<PointsPerWeekGraph> createState() => _PointsPerWeekGraph();
}

class _PointsPerWeekGraph extends State<PointsPerWeekGraph> {
  int? selectedLineIndex; // null when no line is selected

  late bool isShowingPointData = true;
  double reservedSize = 60;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    isShowingPointData
                        ? "Points Per Week"
                        : "Standings Per Week",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShowingPointData = !isShowingPointData;
                    });
                  },
                  icon: Icon(
                    Icons.swap_vert,
                    color: Colors.blue,
                    size: 28,
                  ),
                  tooltip:
                      "Switch to ${isShowingPointData ? 'Standings' : 'Points'} View",
                ),
              ],
            ),
            // Main content row with chart and legend
            SizedBox(
              height: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chart
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        isShowingPointData ? pointData : standingData,
                        duration: const Duration(milliseconds: 500),
                      ),
                    ),
                  ),

                  // Legend
                  buildLegend(colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData get pointData => LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final rosterIndex = spot.barIndex;
                final roster = widget.filteredRosters[rosterIndex];
                final rosterName =
                    roster.displayName ?? 'Roster ${rosterIndex + 1}';
                final color = colors[rosterIndex % colors.length];

                return LineTooltipItem(
                  textAlign: TextAlign.left,
                  '${spot.y.toStringAsFixed(2)} - $rosterName',
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    //overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
            show: true, drawVerticalLine: false, horizontalInterval: 10),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: reservedSize,
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
              //interval: 1,
              reservedSize: reservedSize,
            ),
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: const Color(0xff37434d))),
        minX: 1,
        maxX: getMaxWeek(),
        minY: getMinPoints(),
        maxY: getMaxPoints(),
        lineBarsData: getLineBarsPointData(colors),
      );

  LineChartData get standingData => LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final rosterIndex = spot.barIndex;
                final roster = widget.filteredRosters[rosterIndex];
                final rosterName =
                    roster.displayName ?? 'Roster ${rosterIndex + 1}';
                final color = colors[rosterIndex % colors.length];

                int flipped = spot.y.toInt();
                int position = widget.filteredRosters.length - (flipped - 1);

                String positionText = '$position';

                if (position == 1) {
                  positionText = '1st';
                } else if (position == 2) {
                  positionText = '2nd';
                } else if (position == 3) {
                  positionText = '3rd';
                } else {
                  positionText = '${position}th';
                }

                return LineTooltipItem(
                  textAlign: TextAlign.left,
                  '$positionText - $rosterName',
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    //overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
            show: true, drawVerticalLine: false, horizontalInterval: 1),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: reservedSize,
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
              showTitles: true,
              interval: 1,
              reservedSize: reservedSize,
              getTitlesWidget: (value, meta) {
                int flipped = value.toInt();
                int position = widget.filteredRosters.length - (flipped - 1);
                String positionText = '$position';

                if (position == 1) {
                  positionText += 'st';
                } else if (position == 2) {
                  positionText += 'nd';
                } else if (position == 3) {
                  positionText += 'rd';
                } else {
                  positionText += 'th';
                }

                return SideTitleWidget(
                    child: Text(
                      positionText,
                      style: TextStyle(fontSize: 12),
                    ),
                    meta: meta);
              },
            ),
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: const Color(0xff37434d))),
        minX: 1,
        maxX: getMaxWeek(),
        minY: 1,
        maxY: widget.filteredRosters.length.toDouble(),
        lineBarsData: getLineBarsStandingData(colors),
      );

  List<LineChartBarData> getLineBarsPointData(List<Color> colors) {
    List<LineChartBarData> lines = [];

    // Create a line for each roster
    for (int i = 0; i < widget.filteredRosters.length; i++) {
      final roster = widget.filteredRosters[i];
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

  List<LineChartBarData> getLineBarsStandingData(List<Color> colors) {
    List<LineChartBarData> lines = [];

    // Find the weekly standings for each week
    Map<int, List<Map<String, dynamic>>> weeklyStandings = {};

    for (int week = 0; week < getMaxWeek().toInt(); week++) {
      weeklyStandings[week + 1] = [];

      for (int i = 0; i < widget.filteredRosters.length; i++) {
        final roster = widget.filteredRosters[i];
        double points = 0.0;

        if (week < roster.truePoints.length) {
          points = roster.truePoints[week];
        }

        weeklyStandings[week + 1]!.add({
          "rosterIndex": i,
          "roster": roster,
          "points": points,
        });
      }

      // Sort by points (descending) to determine standings
      weeklyStandings[week + 1]!
          .sort((a, b) => b['points'].compareTo(a['points']));
    }

    // Now create a line for each roster showing their standing over time
    for (int i = 0; i < widget.filteredRosters.length; i++) {
      final roster = widget.filteredRosters[i];
      final color = colors[i % colors.length];
      List<FlSpot> spots = [];

      // Go through each week and find this roster's standing
      for (int week = 1; week <= getMaxWeek().toInt(); week++) {
        if (weeklyStandings.containsKey(week)) {
          final weekData = weeklyStandings[week]!;

          // Find the standing of this roster for this week
          int standing = 1;
          for (int j = 0; j < weekData.length; j++) {
            if (weekData[j]['rosterIndex'] == i) {
              standing =
                  j + 1; // +1 because index starts at 0, standings start at 1
              break;
            }
          }

          // Only add if there was actual data for this week
          if (weekData
              .any((item) => item['rosterIndex'] == i && item['points'] > 0)) {
            final flippedStanding =
                widget.filteredRosters.length - (standing - 1);
            spots.add(FlSpot(week.toDouble(), flippedStanding.toDouble()));
          }
        }
      }
      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty) {
        lines.add(
          LineChartBarData(
            isCurved: false,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
            spots: spots,
          ),
        );
      }
    }

    return lines;
  }

  double getMaxWeek() {
    double maxWeek = widget.filteredRosters.first.truePoints.length.toDouble();
    return maxWeek;
  }

  double getMaxPoints() {
    double maxPoints = 0;

    for (final roster in widget.filteredRosters) {
      final maxInRoster =
          roster.truePoints.isNotEmpty ? roster.truePoints.reduce(max) : 0.0;
      maxPoints = max(maxPoints, maxInRoster);
    }

    return maxPoints;
  }

  double getMinPoints() {
    double minPoints = double.infinity;

    for (final roster in widget.filteredRosters) {
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
  Widget buildLegend(List<Color> colors) {
    // Array of colors for different lines - same as in getLineBarsData

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
          direction: Axis.horizontal,
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: List.generate(
            widget.filteredRosters.length,
            (index) {
              final color = colors[index % colors.length];
              final roster = widget.filteredRosters[index];

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
