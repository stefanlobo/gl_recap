import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/app/di.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/matchup_week.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/model/transaction.dart';
import 'package:guillotine_recap/model/user.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/dio_factory.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/network/network_info.dart';
import 'package:guillotine_recap/repository/repository.dart';
import 'package:guillotine_recap/repository/repository_impl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final leagueNumberProvider = StateProvider<String>((ref) {
  return '1124849636478046208'; // Other league to try : (B, 1124823008221884416), (S, 1124849636478046208), (C, 1117541005508644864, kicked people out so ownerID is null)
  // Not a gleague: 1124834174071492608
});

final leagueProvider = FutureProvider.autoDispose<League>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final league = await ref.watch(sleeperRepositoryProvider).getLeague(leagueId: leagueNumber);

  return league;
});

final rosterProvider = FutureProvider.autoDispose<List<Roster>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);
  final rosters = await ref.watch(sleeperRepositoryProvider).getRoster(leagueId: leagueNumber);

  return rosters;
});

final usersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final users = await ref.watch(sleeperRepositoryProvider).getUsers(leagueId: leagueNumber);

  return users;
});

final weeksProvider = FutureProvider.autoDispose<Map<int, Map<int, MatchupWeek>>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);
  final weeks = await ref.watch(sleeperRepositoryProvider).getAllWeeks(leagueId: leagueNumber);

  return weeks;
});

final filterUserIdProvider = StateProvider<String?>((ref) {
  return null;
});

final combinedRosterProvider = FutureProvider.autoDispose<List<RosterLeague>>(
  (ref) async {
    final users = await ref.watch(usersProvider.future);
    final rosters = await ref.watch(rosterProvider.future);
    final weeksData = await ref.watch(weeksProvider.future);

    final userMap = {for (var user in users) user.userId: user};

    final rosterLeagues = <RosterLeague>[];

    for (final roster in rosters) {
      final user = userMap[roster.ownerId];

      if (user != null) {
        final weeksMap = <int, MatchupWeek>{};

        for (final weekEntry in weeksData.entries) {
          final matchup = weekEntry.value[roster.rosterId];
          if (matchup != null) {
            weeksMap[weekEntry.key] = matchup;
          }
        }

        rosterLeagues.add(RosterLeague(
            userId: user.userId,
            displayName: user.displayName,
            rosterId: roster.rosterId,
            avatar: user.avatar,
            weeks: weeksMap));
      }
    }

    // // Now calculate all the derived values in one go
    // if (rosterLeagues.isNotEmpty) {
    //   RosterLeagueCalculator.calculateAllRosterStats(rosterLeagues);
    // }

    return rosterLeagues;
  },
);

// This is for filtering out the one roster stop that you might have due to sleeper requiring an even nunmber of league members
final filteredRosterLeaguesProvider = Provider.autoDispose<List<RosterLeague>>((ref) {
  // Get the unfiltered data
  final allRosterLeaguesAsync = ref.watch(combinedRosterProvider);
  // Get the filter
  final filteredUserName = ref.watch(filterUserIdProvider);

  // Return a loading state while waiting for unfiltered data
  return allRosterLeaguesAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (allRosterLeagues) {
      // Apply filter if there is one
      final filteredLeagues = filteredUserName != null
          ? allRosterLeagues.where((rl) => rl.displayName != filteredUserName).toList()
          : List<RosterLeague>.from(allRosterLeagues);

      // Calculate the stats if we have leagues
      if (filteredLeagues.isNotEmpty) {
        // Create deep copies to avoid modifying the original objects
        final leagueCopies = filteredLeagues
            .map((rl) => RosterLeague(
                  userId: rl.userId,
                  displayName: rl.displayName,
                  rosterId: rl.rosterId,
                  avatar: rl.avatar,
                  weeks: Map.from(rl.weeks),
                ))
            .toList();

        // Calculate stats
        RosterLeagueCalculator.calculateAllRosterStats(leagueCopies);
        return leagueCopies;
      }

      return [];
    },
  );
});

// Find all transactions so we can run stats on players
final transactionProvider = FutureProvider.autoDispose<Map<int, List<Transaction>>>((ref) async {
  ref.keepAlive();
  final leagueNumber = ref.watch(leagueNumberProvider);

  final transactions = await ref.watch(sleeperRepositoryProvider).getAllTransactions(leagueId: leagueNumber);

  return transactions;
});
