import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/app/di.dart';
import 'package:guillotine_recap/model/combined.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/matchup_week.dart';
import 'package:guillotine_recap/model/roster.dart';
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
  return '1124849636478046208';
});

final leagueProvider = FutureProvider.autoDispose<League>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final league = await ref
      .watch(sleeperRepositoryProvider)
      .getLeague(leagueId: leagueNumber);

  return league;
});

final rosterProvider = FutureProvider.autoDispose<List<Roster>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final rosters = await ref
      .watch(sleeperRepositoryProvider)
      .getRoster(leagueId: leagueNumber);

  return rosters;
});

final usersProvider = FutureProvider.autoDispose<List<User>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final rosters = await ref
      .watch(sleeperRepositoryProvider)
      .getUsers(leagueId: leagueNumber);

  return rosters;
});

final weeksProvider =
    FutureProvider.autoDispose<Map<int, Map<int, MatchupWeek>>>((ref) async {
  final leagueNumber = ref.watch(leagueNumberProvider);

  final weeks = await ref
      .watch(sleeperRepositoryProvider)
      .getAllWeeks(leagueId: leagueNumber);

  return weeks;
});

final combinedRosterProvider =
    FutureProvider.autoDispose<Combined>((ref) async {
  final users = await ref.watch(usersProvider.future);
  final rosters = await ref.watch(rosterProvider.future);
  final weeks = await ref.watch(weeksProvider.future);

  final combined = await ref
      .read(sleeperRepositoryProvider)
      .combineData(rosters: rosters, users: users, weeklyData: weeks);

  return combined;
});
