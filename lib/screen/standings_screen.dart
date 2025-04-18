import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guillotine_recap/widgets/charts_card.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'dart:core';
import 'dart:math';

import 'package:guillotine_recap/widgets/standings_card.dart';

class Standings extends StatefulWidget {
  final List<RosterLeague> filteredRosters;

  const Standings({
    Key? key,
    required this.filteredRosters,
  }) : super(key: key);

  @override
  State<Standings> createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  bool _isSortAcc = true;
  List<RosterLeague> _sortedRosters = [];

  ScrollController _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateSortedRosters();
  }

  @override
  void didUpdateWidget(Standings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filteredRosters != oldWidget.filteredRosters) {
      _updateSortedRosters();
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  void _updateSortedRosters() {
    // Create a new list (don't modify the original)
    _sortedRosters = List.from(widget.filteredRosters);
    _isSortAcc = true;
    sortDeathWeek();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width to help with sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: min(screenWidth * 0.95,
                  2000), // Constrain max width, use min to avoid overflows
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StandingsCard(columns: _createColumn(), rows: _createRows()),
                PointsPerWeekGraph(
                  filteredRosters: _sortedRosters,
                ),
              ],
            )),
      ),
    );
  }

  List<DataColumn> _createColumn() {
    return [
      const DataColumn(label: Text("Username")),
      DataColumn(
        label: Text("Death Week"),
        onSort: (columnIndex, ascending) {
          sortDeathWeek();
        },
      ),
      DataColumn(
        label: Text("Death Points"),
        onSort: (columnIndex, ascending) {
          setState(() {
            if (_isSortAcc) {
              _sortedRosters.sort((a, b) {
                if (a.deathPoints == null && b.deathPoints == null) return 0;
                if (a.deathPoints == null) return -1; // a is "greater"
                if (b.deathPoints == null) return 1; // b is "greater"
                return b.deathPoints!
                    .compareTo(a.deathPoints!); // both non-null
              });
            } else {
              _sortedRosters.sort((a, b) {
                if (a.deathPoints == null && b.deathPoints == null) return 0;
                if (a.deathPoints == null) return 1; // a is "greater"
                if (b.deathPoints == null) return -1; // b is "greater"
                return a.deathPoints!
                    .compareTo(b.deathPoints!); // both non-null
              });
            }

            _isSortAcc = !_isSortAcc;
          });
        },
      ),
      DataColumn(
        label: Text("Total Points"),
        onSort: (columnIndex, ascending) {
          setState(() {
            if (_isSortAcc) {
              _sortedRosters.sort((a, b) {
                final a_tp = a.truePoints.reduce((a, b) => a + b);
                final b_tp = b.truePoints.reduce((a, b) => a + b);
                return b_tp.compareTo(a_tp); // both non-null
              });
            } else {
              _sortedRosters.sort((a, b) {
                final a_tp = a.truePoints.reduce((a, b) => a + b);
                final b_tp = b.truePoints.reduce((a, b) => a + b);
                return a_tp.compareTo(b_tp); // both non-null
              });
            }

            _isSortAcc = !_isSortAcc;
          });
        },
      ),
    ];
  }

  // Helper function to check if a roster is the winner
  bool isWinner(RosterLeague roster) {
    // Check if this player is the last one alive (no death week)
    return roster.deathWeek == null;
  }

  void sortDeathWeek() {
    setState(() {
      if (_isSortAcc) {
        _sortedRosters.sort((a, b) {
          if (a.deathWeek == null && b.deathWeek == null) return 0;
          if (a.deathWeek == null) return -1; // a is "greater"
          if (b.deathWeek == null) return 1; // b is "greater"
          return b.deathWeek!.compareTo(a.deathWeek!); // both non-null
        });
      } else {
        _sortedRosters.sort((a, b) {
          if (a.deathWeek == null && b.deathWeek == null) return 0;
          if (a.deathWeek == null) return 1; // a is "greater"
          if (b.deathWeek == null) return -1; // b is "greater"
          return a.deathWeek!.compareTo(b.deathWeek!); // both non-null
        });
      }

      _isSortAcc = !_isSortAcc;
    });
  }

  List<DataRow> _createRows() {
    return _sortedRosters.map((e) {
      bool winner = isWinner(e);
      return DataRow(cells: [
        DataCell(Text(e.displayName)),
        DataCell(
          Row(
            children: [
              Text(e.deathWeek?.toString() ?? "Winner"),
              if (winner)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
        DataCell(Text(e.deathPoints?.toString() ?? "N/A")),
        DataCell(Text(e.truePoints.reduce((a, b) => a + b).toStringAsFixed(2))),
      ]);
    }).toList();
  }
}
