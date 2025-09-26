// Utils/AppGradients.dart
import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';

class AppGradients {
  static const LinearGradient topToBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primary,
     AppColors.gradient2,
    ],
  );
}
