import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/dio_factory.dart';
import 'package:guillotine_recap/network/failure.dart';
import 'package:guillotine_recap/network/network_info.dart';
import 'package:guillotine_recap/repository/repository.dart';
import 'package:guillotine_recap/repository/repository_impl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


final dioProvider = FutureProvider<Dio>((ref) async {
  return DioFactory().getDio();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(InternetConnectionChecker());
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider).requireValue;
  final networkInfo = ref.watch(networkInfoProvider);
  return ApiService(dio, networkInfo);
});

final sleeperRepositoryProvider = Provider<Repository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RepositoryImpl(apiService);
});