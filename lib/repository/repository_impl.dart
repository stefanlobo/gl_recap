import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/error_handler.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/repository/repository.dart';

class RepositoryImpl implements Repository {
  final ApiService _apiService;

  RepositoryImpl(this._apiService);

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
}
