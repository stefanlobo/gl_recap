import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/widgets/charts_card.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'dart:core';
import 'dart:math';

import 'package:guillotine_recap/widgets/standings_card.dart';

final standingsSortProvider = StateNotifierProvider.autoDispose<StandingsSortNotifier, StandingsSortState>((ref) {
  final filteredRosters = ref.watch(filteredRosterLeaguesProvider);
  return StandingsSortNotifier(filteredRosters);
});

class StandingsSortState {
  final List<RosterLeague> sortedRosters;
  final bool isSortAscending;

  StandingsSortState({
    required this.sortedRosters,
    this.isSortAscending = false,
  });

  StandingsSortState copyWith({
    List<RosterLeague>? sortedRosters,
    bool? isSortAscending,
  }) {
    return StandingsSortState(
      sortedRosters: sortedRosters ?? this.sortedRosters,
      isSortAscending: isSortAscending ?? this.isSortAscending,
    );
  }
}

class StandingsSortNotifier extends StateNotifier<StandingsSortState> {
  StandingsSortNotifier(List<RosterLeague> initialRosters)
      : super(StandingsSortState(sortedRosters: List.from(initialRosters))) {
    sortByDeathWeek();
  }

  void sortByDeathWeek() {
    final newSortAscending = !state.isSortAscending;
    final sortedList = List<RosterLeague>.from(state.sortedRosters);

    if (newSortAscending) {
      sortedList.sort((a, b) {
        if (a.deathWeek == null && b.deathWeek == null) return 0;
        if (a.deathWeek == null) return -1;
        if (b.deathWeek == null) return 1;
        return b.deathWeek!.compareTo(a.deathWeek!);
      });
    } else {
      sortedList.sort((a, b) {
        if (a.deathWeek == null && b.deathWeek == null) return 0;
        if (a.deathWeek == null) return 1;
        if (b.deathWeek == null) return -1;
        return a.deathWeek!.compareTo(b.deathWeek!);
      });
    }

    state = state.copyWith(
      sortedRosters: sortedList,
      isSortAscending: newSortAscending,
    );
  }

  void sortByDeathPoints() {
    final newSortAscending = !state.isSortAscending;
    final sortedList = List<RosterLeague>.from(state.sortedRosters);

    if (newSortAscending) {
      sortedList.sort((a, b) {
        if (a.deathPoints == null && b.deathPoints == null) return 0;
        if (a.deathPoints == null) return -1;
        if (b.deathPoints == null) return 1;
        return b.deathPoints!.compareTo(a.deathPoints!);
      });
    } else {
      sortedList.sort((a, b) {
        if (a.deathPoints == null && b.deathPoints == null) return 0;
        if (a.deathPoints == null) return 1;
        if (b.deathPoints == null) return -1;
        return a.deathPoints!.compareTo(b.deathPoints!);
      });
    }

    state = state.copyWith(
      sortedRosters: sortedList,
      isSortAscending: newSortAscending,
    );
  }

  void sortByTotalPoints() {
    final newSortAscending = !state.isSortAscending;
    final sortedList = List<RosterLeague>.from(state.sortedRosters);

    if (newSortAscending) {
      sortedList.sort((a, b) {
        final aTp = a.truePoints.reduce((a, b) => a + b);
        final bTp = b.truePoints.reduce((a, b) => a + b);
        return bTp.compareTo(aTp);
      });
    } else {
      sortedList.sort((a, b) {
        final aTp = a.truePoints.reduce((a, b) => a + b);
        final bTp = b.truePoints.reduce((a, b) => a + b);
        return aTp.compareTo(bTp);
      });
    }

    state = state.copyWith(
      sortedRosters: sortedList,
      isSortAscending: newSortAscending,
    );
  }
}

class Standings extends ConsumerWidget {
  const Standings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get sorted rosters from the provider
    final sortState = ref.watch(standingsSortProvider);
    final sortedRosters = sortState.sortedRosters;

    // Get the screen width to help with sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: min(screenWidth * 0.95, 1500), // Constrain max width, use min to avoid overflows
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StandingsCard(columns: _createColumn(ref), rows: _createRows(sortedRosters)),
                PointsPerWeekGraph(
                  filteredRosters: sortedRosters,
                ),
              ],
            )),
      ),
    );
  }

  List<DataColumn> _createColumn(WidgetRef ref) {
    return [
      const DataColumn(label: Text("Username")),
      DataColumn(
        label: Text("Death Week"),
        onSort: (_, __) {
          ref.read(standingsSortProvider.notifier).sortByDeathWeek();
        },
      ),
      DataColumn(
        label: Text("Death Points"),
        onSort: (_, __) {
          ref.read(standingsSortProvider.notifier).sortByDeathPoints();
        },
      ),
      DataColumn(
        label: Text("Total Points"),
        onSort: (_, __) {
          ref.read(standingsSortProvider.notifier).sortByTotalPoints();
        },
      ),
    ];
  }

  // Helper function to check if a roster is the winner
  bool isWinner(RosterLeague roster) {
    // Check if this player is the last one alive (no death week)
    return roster.deathWeek == null;
  }

  List<DataRow> _createRows(List<RosterLeague> sortedRosters) {
    return sortedRosters.map((e) {
      bool winner = isWinner(e);
      print(e.avatar);
      return DataRow(cells: [
        DataCell(Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(e.avatarUrl),
              onBackgroundImageError: (_, __) => Icon(Icons.person),
            ),
            SizedBox(width: 12),
            Text(e.displayName),
          ],
        )),
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
