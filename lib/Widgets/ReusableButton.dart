import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final bool? isRounded;
  final bool? isLoading;

  const ReusableButton({super.key, 
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.isRounded,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(isRounded == true ? 100 : 6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(isRounded == true ? 100 : 6),
          ),
          child: Center(
            child: isLoading!
                ? SizedBox(
              height: 35,
                child: CircularProgressIndicator())
            : Text(
              text,
              style: FFontStyles.button(16),
            ),
          ),
        ),
      ),
    );
  }
}
