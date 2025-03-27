import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/app/app.dart';
import 'package:guillotine_recap/app/di.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
}
