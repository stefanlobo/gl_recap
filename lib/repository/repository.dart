import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/matchup_week.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/model/user.dart';
import 'package:guillotine_recap/network/failure.dart';

abstract class SleeperRepository {
  Future<List<Roster>> getRoster({required String leagueId});
  Future<League> getLeague({required String leagueId});
  Future<List<User>> getUsers({required String leagueId});

  Future<Map<int, Map<int, MatchupWeek>>> getAllWeeks({
    required String leagueId,
    int maxWeeks = 18, // Typical NFL season length
  });
}
