import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'dart:math';

import 'package:guillotine_recap/screen/standings_screen.dart';

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
  int? selectedLineIndex; // null when no line is selected\
  List<RosterLeague> finalRoster = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalRoster = List.from(widget.filteredRosters);
    finalRoster.sort((a, b) => a.rosterId.compareTo(b.rosterId));
  }

  @override
  void didUpdateWidget(PointsPerWeekGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filteredRosters != oldWidget.filteredRosters) {
      finalRoster = List.from(widget.filteredRosters);
      finalRoster.sort((a, b) => a.rosterId.compareTo(b.rosterId));
    }
  }

  late bool isShowingPointData = true;
  bool isViewChanging = false;
  double reservedSize = 60;

  final colors = [
    Colors.blue,
    Colors.red,
    Colors.amber,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.lime,
    Colors.brown,
    Colors.cyan,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.grey,
    Colors.blueGrey,
    Colors.deepPurple,
    Colors.yellow,
    Colors.grey,
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
                    isShowingPointData ? "Points Per Week" : "Standings Per Week",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isViewChanging = true;
                      isShowingPointData = !isShowingPointData;
                    });

                    // Reset the view changing flag after animation completes
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          isViewChanging = false;
                        });
                      }
                    });
                  },
                  icon: Icon(
                    Icons.swap_vert,
                    color: Colors.blue,
                    size: 28,
                  ),
                  tooltip: "Switch to ${isShowingPointData ? 'Standings' : 'Points'} View",
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
                        duration: isViewChanging ? const Duration(milliseconds: 500) : Duration.zero,
                      ),
                    ),
                  ),

                  // Legend
                  Center(child: buildLegend(colors)),
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
                // final rosterIndex = spot.barIndex;
                // final roster = finalRoster[rosterIndex];
                final barIndex = spot.barIndex;
                final rosterIndex = lineIndexToRosterIndex[barIndex] ?? barIndex;
                final roster = finalRoster[rosterIndex];
                final rosterName = roster.displayName ?? 'Roster ${rosterIndex + 1}';
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
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10),
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
        borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d))),
        minX: 1,
        maxX: getMaxWeek(),
        minY: getMinPoints(),
        maxY: getMaxPoints(),
        lineBarsData: reorderLinesWithSelectionOnTop(getLineBarsPointData(colors)),
      );

  LineChartData get standingData => LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                // final rosterIndex = spot.barIndex;
                // final roster = finalRoster[rosterIndex];
                final barIndex = spot.barIndex;
                final rosterIndex = lineIndexToRosterIndex[barIndex] ?? barIndex;
                final roster = finalRoster[rosterIndex];
                final rosterName = roster.displayName ?? 'Roster ${rosterIndex + 1}';
                final color = colors[rosterIndex % colors.length];

                int flipped = spot.y.toInt();
                int position = finalRoster.length - (flipped - 1);

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
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1),
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
                int position = finalRoster.length - (flipped - 1);
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
        borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d))),
        minX: 1,
        maxX: getMaxWeek(),
        minY: 1,
        maxY: finalRoster.length.toDouble(),
        lineBarsData: reorderLinesWithSelectionOnTop(getLineBarsStandingData(colors)),
      );

  List<LineChartBarData> getLineBarsPointData(List<Color> colors) {
    List<LineChartBarData> lines = [];

    // Create a line for each roster
    for (int i = 0; i < finalRoster.length; i++) {
      bool isSelected = selectedLineIndex == i;

      final roster = finalRoster[i];
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
      lines.add(_customLineChartBarData(color, spots, isSelected));
    }

    return lines;
  }

  List<LineChartBarData> getLineBarsStandingData(List<Color> colors) {
    List<LineChartBarData> lines = [];

    // Find the weekly standings for each week
    Map<int, List<Map<String, dynamic>>> weeklyStandings = {};

    for (int week = 0; week < getMaxWeek().toInt(); week++) {
      weeklyStandings[week + 1] = [];

      for (int i = 0; i < finalRoster.length; i++) {
        final roster = finalRoster[i];
        double points = 0.0;

        if (week < roster.truePoints.length) {
          points = roster.truePoints[week];
        }

        // For true points, the week is normal indexing i.e start at 0, however, here we want to start with week 1
        weeklyStandings[week + 1]!.add({
          "rosterIndex": i,
          "roster": roster,
          "points": points,
        });
      }

      // Sort by points (descending) to determine standings
      weeklyStandings[week + 1]!.sort((a, b) => b['points'].compareTo(a['points']));
    }

    // Now create a line for each roster showing their standing over time
    for (int i = 0; i < finalRoster.length; i++) {
      bool isSelected = selectedLineIndex == i;

      final roster = finalRoster[i];
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
              standing = j + 1; // +1 because index starts at 0, standings start at 1
              break;
            }
          }

          // Only add if there was actual data for this week
          if (weekData.any((item) => item['rosterIndex'] == i && item['points'] > 0)) {
            final flippedStanding = finalRoster.length - (standing - 1);
            spots.add(FlSpot(week.toDouble(), flippedStanding.toDouble()));
          }
        }
      }
      spots.sort((a, b) => a.x.compareTo(b.x));

      if (spots.isNotEmpty) {
        lines.add(_customLineChartBarData(color, spots, isSelected));
      }
    }

    return lines;
  }

  Map<int, int> lineIndexToRosterIndex = {};

  List<LineChartBarData> reorderLinesWithSelectionOnTop(List<LineChartBarData> lines) {
    // Initialize the mapping (bar index → roster index)
    lineIndexToRosterIndex.clear();
    for (int i = 0; i < lines.length; i++) {
      lineIndexToRosterIndex[i] = i;
    }

    if (selectedLineIndex == null || selectedLineIndex! >= lines.length) {
      return lines; // No need to reorder if nothing is selected
    }

    // Create a new list without modifying the original
    List<LineChartBarData> reorderedLines = List.from(lines);

    // Remove the selected line
    final selectedLine = reorderedLines.removeAt(selectedLineIndex!);

    // Add it back at the end so it's drawn last (on top)
    reorderedLines.add(selectedLine);

    // Update the mapping to reflect the new order
    lineIndexToRosterIndex.clear();
    for (int i = 0; i < selectedLineIndex!; i++) {
      lineIndexToRosterIndex[i] = i;
    }
    for (int i = selectedLineIndex!; i < lines.length - 1; i++) {
      lineIndexToRosterIndex[i] = i + 1;
    }
    lineIndexToRosterIndex[lines.length - 1] = selectedLineIndex!;

    return reorderedLines;
  }

  LineChartBarData _customLineChartBarData(color, spots, isSelected) {
    return LineChartBarData(
      isCurved: false,
      color: color,
      barWidth: isSelected ? 4.0 : 2.0,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: isSelected ? 8.0 : 3.0, // Larger dots for selected
            color: color,
            strokeWidth: isSelected ? 4.0 : 1.0,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  double getMaxWeek() {
    double maxWeek = finalRoster.first.truePoints.length.toDouble();
    return maxWeek;
  }

  double getMaxPoints() {
    double maxPoints = 0;

    for (final roster in finalRoster) {
      final maxInRoster = roster.truePoints.isNotEmpty ? roster.truePoints.reduce(max) : 0.0;
      maxPoints = max(maxPoints, maxInRoster);
    }

    return maxPoints;
  }

  double getMinPoints() {
    double minPoints = double.infinity;

    for (final roster in finalRoster) {
      // Filter out zeros and empty lists
      final nonZeroPoints = roster.truePoints.where((point) => point > 0).toList();

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      // decoration: BoxDecoration(
      //   color: const Color.fromARGB(255, 185, 19, 19),
      //   borderRadius: BorderRadius.circular(8.0),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: List.generate(
          finalRoster.length,
          (index) {
            final color = colors[index % colors.length];
            final roster = finalRoster[index];
            final rosterName = roster.displayName ?? 'Roster ${index + 1}';

            // Check if this is the selected roster
            final isSelected = selectedLineIndex == index;

            return GestureDetector(
              onTap: () {
                print('Legend item tapped: $index');
                setState(() {
                  // Toggle selection - if already selected, clear it, otherwise select this one
                  if (selectedLineIndex == index) {
                    selectedLineIndex = null;
                  } else {
                    selectedLineIndex = index;
                  }
                  print('Selection is now: $selectedLineIndex');
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isSelected ? color : Colors.transparent, width: 1.5),
                ),
                child: Row(
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
                    SizedBox(width: 4),
                    Text(
                      rosterName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
