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
      print("Fetching rosters with ID: $leagueId"); // Debug print

      final response =
          await _apiService.get(endPoint: "league/$leagueId/rosters");

      if (response.statusCode != 200) {
        print("Non-200 status code: ${response.statusCode}");
        print("Response data: ${response.data}");
      }

      if (response.data == null) {
        print("getRoster: Response data is null");
        throw createEmptyDataException(response);
      }

      if (response.data is List && response.data.isEmpty) {
        print("getRoster: Response data is empty list");
        throw createEmptyDataException(response);
      }

      final data = convertListToModel(Roster.fromJson, response.data!);

      return data;
    } catch (error) {
      print("Error fetching rosters under $leagueId: $error");

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
        print("Fetching week $week with ID: $leagueId"); // Debug print

        final response =
            await _apiService.get(endPoint: "league/$leagueId/matchups/$week");

        if (response.statusCode != 200) {
          print("Non-200 status code: ${response.statusCode}");
          print("Response data: ${response.data}");
        }

        if (response.data == null) {
          print("getAllWeeks for week $week: Response data is null");
          throw createEmptyDataException(response);
        }

        if (response.data is List && response.data.isEmpty) {
          print("getAllWeeks for week $week: Response data is empty list");
          throw createEmptyDataException(response);
        }

        if (response.statusCode == 200 && response.data != null) {
          print("Successfully parsed week $week data for ID: $leagueId");
          final matchups =
              convertListToModel(MatchupWeek.fromJson, response.data!);

          weeklyData[week] = {
            for (var matchup in matchups) matchup.rosterId: matchup
          };
        } else if (response.data == null) {
          print("No week $week data");

          break;
        }
      } catch (error) {
        print("Error fetching weeks under $leagueId: $error");
        throw ErrorHandler.handle(error).failure;
      }

      week++;
    }

    return weeklyData;
  }

  @override
  Future<League> getLeague({required String leagueId}) async {
    try {
      print("Fetching league with ID: $leagueId"); // Debug print

      final response = await _apiService.get(endPoint: "league/$leagueId");

      print(
          "League API response status: ${response.statusCode}"); // Debug print

      if (response.statusCode != 200) {
        print("Non-200 status code: ${response.statusCode}");
        print("Response data: ${response.data}");
      }

      if (response.data == null) {
        print("getLeague Response data is null");
        throw createEmptyDataException(response);
      }

      if (response.data is List && response.data.isEmpty) {
        print("getLeague Response data is empty list");
        throw createEmptyDataException(response);
      }

      final data = convertMapToModel(League.fromJson, response.data!);
      print("Successfully parsed league data for ID: $leagueId");

      return data;
    } catch (error) {
      print("Error fetching league ID $leagueId: $error");
      throw ErrorHandler.handle(error).failure;
    }
  }

  @override
  Future<List<User>> getUsers({required String leagueId}) async {
    try {
      print("Fetching users with: $leagueId"); // Debug print

      final response =
          await _apiService.get(endPoint: "league/$leagueId/users");

      print("User API response status: ${response.statusCode}"); // Debug print

      if (response.statusCode != 200) {
        print("Non-200 status code: ${response.statusCode}");
        print("Response data: ${response.data}");
      }

      if (response.data == null) {
        print("getUsers Response data is null");
        throw createEmptyDataException(response);
      }

      if (response.data is List && response.data.isEmpty) {
        print("getLeague Response data is empty list");
        throw createEmptyDataException(response);
      }

      final data = convertListToModel(User.fromJson, response.data!);

      return data;
    } catch (error) {
      print("Error fetching users under $leagueId: $error");

      throw ErrorHandler.handle(error).failure;
    }
  }
}
