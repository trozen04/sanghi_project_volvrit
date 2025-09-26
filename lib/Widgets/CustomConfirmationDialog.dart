import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'ReusableButton.dart';

class CustomConfirmationDialog {
  // Show dialog
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = 'Yes',
    String cancelText = 'No',
    Color confirmColor = AppColors.logoutColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: FFontStyles.customAppBarTitleText(18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: FFontStyles.noAccountText(14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ReusableButton(
                        text: cancelText,
                        onPressed: () => Navigator.pop(context, false),
                        color: AppColors.myOrdersApproved,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ReusableButton(
                        text: confirmText,
                        onPressed: () => Navigator.pop(context, true),
                        color: confirmColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false; // return false if dismissed
  }
}
