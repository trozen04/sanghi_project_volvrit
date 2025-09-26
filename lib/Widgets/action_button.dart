import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isRight;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    // Build the children list depending on isRight
    final children = isRight
        ? <Widget>[
      Text(
        label,
        style: FFontStyles.titleText(12).copyWith(color: AppColors.primary),
      ),
      const SizedBox(width: 8),
      Icon(icon, color: AppColors.primary, size: 20),
    ]
        : <Widget>[
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(width: 8),
      Text(
        label,
        style: FFontStyles.titleText(12).copyWith(color: AppColors.primary),
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.filterBG,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
