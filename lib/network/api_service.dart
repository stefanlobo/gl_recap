import 'package:dio/dio.dart';
import 'package:guillotine_recap/app/constants.dart';

import 'error_handler.dart';
import 'network_info.dart';

class ApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  ApiService(this._dio, this._networkInfo) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  //region Init function for interceptor

  _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (await _networkInfo.isConnected) {
      // String? token = _appPref.getToken();
      // options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    } else {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: ResponseCode.noInternetConnection,
            statusMessage: ResponseMessage.noInternetConnection,
          ),
          error: ResponseMessage.noInternetConnection,
        ),
      );
    }
  }

  
  _onError(DioException e, ErrorInterceptorHandler handler) async {
      // Add detailed error logging
      print('DioError: ${e.type}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Error message: ${e.message}');
      handler.next(e); // Continue passing the error
  }

  //endregion

  Future<Response> get({required String endPoint}) async {
    var response = await _dio.get('${Constants.baseUrl}$endPoint');
    return response;
  }

  // Future<Response> post({required String endPoint, dynamic data, dynamic params}) async {
  //   var response = await _dio.post('${Constants.baseUrl}$endPoint', data: data, queryParameters: params);
  //   return response;
  // }

  // Future<Response> put({required String endPoint}) async {
  //   var response = await _dio.put('${Constants.baseUrl}$endPoint');
  //   return response;
  // }

  // Future<Response> delete({required String endPoint}) async {
  //   var response = await _dio.delete('${Constants.baseUrl}$endPoint');
  //   return response;
  // }
}
