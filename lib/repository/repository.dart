import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/failure.dart';



abstract class Repository {
  Future<List<Roster>> getRoster({required String leagueId});
  Future<League> getLeague({required String leagueId});
}