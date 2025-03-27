import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/app/di.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
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
