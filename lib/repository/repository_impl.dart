import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/model/matchup_week.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/model/user.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/error_handler.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/repository/repository.dart';

class SleeperRepositoryImpl implements SleeperRepository {
  final ApiService _apiService;

  SleeperRepositoryImpl(this._apiService);

  @override
  Future<List<Roster>> getRoster({required String leagueId}) async {
    try {
      final response =
          await _apiService.get(endPoint: "league/$leagueId/rosters");

      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        throw createEmptyDataException(response);
      }

      // success
      // return either right
      // return data
      final data = convertListToModel(Roster.fromJson, response.data!);

      return data;
    } catch (error) {
      throw ErrorHandler.handle(error).failure;
    }
  }

  @override
  Future<Map<int, Map<int, MatchupWeek>>> getAllWeeks({
    required String leagueId,
    int maxWeeks = 18, // Typical NFL season length
  }) async {
    int week = 1;

    final Map<int, Map<int, MatchupWeek>> weeklyData = {};

    while (week <= maxWeeks) {
      try {
        final response =
            await _apiService.get(endPoint: "league/$leagueId/matchups/$week");

        if (response.statusCode == 200 && response.data != null) {
          final matchups =
              convertListToModel(MatchupWeek.fromJson, response.data!);

          weeklyData[week] = {
            for (var matchup in matchups) matchup.rosterId: matchup
          };
        } else if (response.data == null) {
          break;
        }
      } catch (error) {
        throw ErrorHandler.handle(error).failure;
      }

      week++;
    }

    return weeklyData;
  }

  @override
  Future<League> getLeague({required String leagueId}) async {
    try {
      final response =
          await _apiService.get(endPoint: "league/$leagueId/rosters");

      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        throw createEmptyDataException(response);
      }

      // success
      // return either right
      // return data
      final data = convertMapToModel(League.fromJson, response.data!);

      return data;
    } catch (error) {
      throw ErrorHandler.handle(error).failure;
    }
  }

  @override
  Future<List<User>> getUsers({required String leagueId}) async {
    try {
      final response =
          await _apiService.get(endPoint: "league/$leagueId/users");

      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        throw createEmptyDataException(response);
      }

      // success
      // return either right
      // return data
      final data = convertListToModel(User.fromJson, response.data!);

      return data;
    } catch (error) {
      throw ErrorHandler.handle(error).failure;
    }
  }
}
