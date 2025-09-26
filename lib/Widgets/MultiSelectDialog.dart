import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';

Future<List<String>?> showMultiSelectDialog({
  required BuildContext context,
  required String title,
  required List<String> options,
  List<String>? initiallySelected,
}) {
  final List<String> selected = List<String>.from(initiallySelected ?? []);

  return showDialog<List<String>>(
    context: context,
    builder: (ctx) {
      final width = MediaQuery.of(ctx).size.width * 0.7; // wider dialog
      return Dialog(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.dialogBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(title, style: FFontStyles.titleText(20)),
              const SizedBox(height: 16),

              // Options list
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: StatefulBuilder(
                    builder: (ctx, setState) {
                      return Column(
                        children: options.map((item) {
                          final isChecked = selected.contains(item);
                          return CheckboxListTile(
                            value: isChecked,
                            title: Text(item, style: FFontStyles.filters(14)),
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: AppColors.primary,
                            fillColor: WidgetStateProperty.resolveWith((states) => AppColors.checkboxColor),
                            side: WidgetStateBorderSide.resolveWith((states) => BorderSide.none),
                            contentPadding: EdgeInsets.zero, // removes horizontal padding
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // tighten spacing
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  selected.add(item);
                                } else {
                                  selected.remove(item);
                                }
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: FFontStyles.button(16),
                    ),
                    onPressed: () => Navigator.pop(ctx, null),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ReusableButton(
                    text: 'Apply',
                    onPressed: () => Navigator.pop(ctx, selected),
                    width: width,
                    isRounded: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
