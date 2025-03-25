import 'package:get_it/get_it.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/network/dio_factory.dart';
import 'package:guillotine_recap/network/network_info.dart';
import 'package:guillotine_recap/repository/league.dart';
import 'package:guillotine_recap/repository/repo.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


final instance = GetIt.instance;

Future<void> initAppModule() async {

  //NetworkInfo instance
  instance.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );
  
  print("${GetIt.I.isRegistered<NetworkInfo>()} " + "NetworkInfo");

  //DioFactory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory());

  final dio = await instance<DioFactory>().getDio();

  //AppServiceClient instance
  instance.registerLazySingleton(() => ApiService(dio, instance(),));


  instance.registerFactory<Repository>(() => RepositoryImpl(instance()));

}