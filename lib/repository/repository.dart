import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/failure.dart';



abstract class Repository {
  Future<Either<Failure, List<Roster>>> getRoster();

  Future<Either<Failure, League>> getLeague();
}