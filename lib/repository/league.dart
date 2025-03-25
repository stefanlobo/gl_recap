import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/convert.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/error_handler.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/repository/repo.dart';

class RepositoryImpl extends Repository {
  final ApiService _apiService;

  RepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<Roster>>> getRoster() async {
    try {
      final response =
          await _apiService.get(endPoint: "league/${1124849636476208}/rosters");
      // success
      // return either right
      // return data
      final data = convertListToModel(Roster.fromJson, response.data!);
      print(data);
      return Right(data);
    } catch (error) {
      print("within repo");
      print(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
