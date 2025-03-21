import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  late Dio _dio;

  final baseUrl = "https://api.sleeper.app/v1/";

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    initializeInterceptors();
  }

  void initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('Error: ${error.message}');
        if (error.response != null) {
          print('Error Response Data: ${error.response?.data}');
          print('Error Status Code: ${error.response?.statusCode}');
        }
        handler.next(error); // Continue the error chain
      },
      onRequest: (request, handler) {
        print('Request: ${request.method} ${request.path}');
        handler.next(request); // Continue the request chain
      },
      onResponse: (response, handler) {
        print('Response: ${response.data}');
        handler.next(response); // Continue the response chain
      },
    ));
  }

  Future<Response> getLeague(String leagueNumber) async {
    Response response;
    print('Starting API call to fetch league: $leagueNumber');

    try {
      response = await _dio.get('league/$leagueNumber');
      print('API call completed successfully');
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  Future<Response> getRosters(String leagueNumber) async {
    Response response;
    print('Starting API call to fetch rosters: $leagueNumber');

    try {
      response = await _dio.get('league/$leagueNumber/rosters');
      print('API call completed successfully');
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

    Future<Response> getUsers(String leagueNumber) async {
    Response response;
    print('Starting API call to fetch users: $leagueNumber');

    try {
      response = await _dio.get('league/$leagueNumber/users');
      print('API call completed successfully');
    } on DioException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  
}
