import 'package:flutter/material.dart';
import 'package:guillotine_recap/app/app.dart';
import 'package:guillotine_recap/di.dart';
import 'package:guillotine_recap/repository/repo.dart';
import 'package:guillotine_recap/screen/home_screen.dart';
import 'network/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  

  final repository = instance<Repository>();
  final result = await repository.getRoster();
  
  result.fold(
    (failure) => print('❌ Error: ${failure.code}'),
    (rosters) {
      print('✅ Success! Received ${rosters.length} rosters');
      for (final roster in rosters) {
        print('Roster ID: ${roster.rosterId}');
        print('Owner ID: ${roster.ownerId}');
        print('------');
      }
    },
  );

  runApp(const MyApp());
}
