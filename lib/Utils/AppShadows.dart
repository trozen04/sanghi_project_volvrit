import 'package:flutter/material.dart';

class AppShadows {
  static BoxShadow customShadow = BoxShadow(
    color: const Color(0xFFE4E5E7).withOpacity(0.24), // 24% opacity
    offset: const Offset(0, 1), // x=0, y=1
    blurRadius: 2,
    spreadRadius: 0,
  );

  // If you want to use in BoxDecoration
  static List<BoxShadow> get boxShadow => [customShadow];
}
