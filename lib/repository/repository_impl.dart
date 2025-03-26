import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/error_handler.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/repository/repository.dart';

class RepositoryImpl extends Repository {
  final ApiService _apiService;
  final String leagueId;

  RepositoryImpl(this._apiService, this.leagueId);

  @override
  Future<Either<Failure, List<Roster>>> getRoster() async {
    try {
      final response =
          await _apiService.get(endPoint: "league/$leagueId/rosters");

      if (response.data == null || (response.data is List && response.data.isEmpty)) {
        throw createEmptyDataException(response);
      }

      // success
      // return either right
      // return data
      final data = convertListToModel(Roster.fromJson, response.data!);

      return Right(data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, League>> getLeague() async {
    try {
      final response =
          await _apiService.get(endPoint: "league/$leagueId/rosters");

      if (response.data == null || (response.data is List && response.data.isEmpty)) {
        throw createEmptyDataException(response);
      }

      // success
      // return either right
      // return data
      final data = convertMapToModel(League.fromJson, response.data!);

      return Right(data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
