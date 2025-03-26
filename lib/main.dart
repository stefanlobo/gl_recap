import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/app/app.dart';
import 'package:guillotine_recap/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();

  // final repository = instance<Repository>(param1: "1124849636478046208");
  // final result = await repository.getRoster();

  // result.fold(
  //   (failure) => print('❌ Error: ${failure.message}'),
  //   (rosters) {
  //     print('✅ Success! Received ${rosters.length} rosters');
  //     for (final roster in rosters) {
  //       print('Roster ID: ${roster.rosterId}');
  //       print('Owner ID: ${roster.ownerId}');
  //       print('------');
  //     }
  //   },
  // );

  runApp(ProviderScope(child: MyApp()));
}
