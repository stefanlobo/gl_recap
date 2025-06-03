// used with dio for convert a single value
import 'dart:math';

import 'package:flutter/material.dart';

T convertMapToModel<T>(T Function(Map<String, dynamic> map) fromJson, Map response) {
  return fromJson((response).cast());
}

// used with dio for convert a List of value
List<T> convertListToModel<T>(T Function(Map<String, dynamic> map) fromJson, List data) {
  return data.map((e) => fromJson((e as Map).cast())).toList();
}

// Helper function to calculate content width
double getContentWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return min(screenWidth * 0.95, 2000.0);
}
