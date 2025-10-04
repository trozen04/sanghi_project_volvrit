import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'dart:developer' as developer;

Future<dynamic> showMultiSelectDropdown({
  required BuildContext context,
  required GlobalKey key,
  required String title,
  required List<String> options, // main dropdown options
  dynamic initiallySelected, // Map<String, List<String>> for main and side
  required Function(List<String>) onSelected,
  bool enableSideDropdown = false,
  bool singleSelection = false,
  bool singleSideSelection = false, // Single selection for side dropdown
  Map<String, List<String>> sideOptionsMap = const {}, // per-main-item sub-options
}) async {
  final List<String> mainSelected = initiallySelected is Map
      ? List<String>.from(initiallySelected['main'] ?? [])
      : List<String>.from(initiallySelected ?? []);
  final Map<String, List<String>> sideSelectedMap = initiallySelected is Map
      ? Map<String, List<String>>.from(initiallySelected['side'] ?? {})
      : {};

  developer.log('Initial mainSelected: $mainSelected, sideSelectedMap: $sideSelectedMap');
  developer.log('sideOptionsMap: $sideOptionsMap');

  final renderBox = key.currentContext!.findRenderObject() as RenderBox;
  final offset = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final overlay = Overlay.of(context);

  late OverlayEntry mainEntry;
  OverlayEntry? sideEntry;
  late OverlayEntry barrier;
  late void Function(void Function()) mainSetState;
  String? currentSideDropdownItem; // Track current side dropdown category

  final completer = Completer<dynamic>();

  void removeAll() {
    if (mainEntry.mounted) mainEntry.remove();
    if (sideEntry?.mounted ?? false) {
      sideEntry?.remove();
      sideEntry = null;
      developer.log('Side dropdown removed');
    }
    if (barrier.mounted) barrier.remove();

    if (!completer.isCompleted) {
      completer.complete({
        'main': List<String>.from(mainSelected), // force it into a List
        'side': Map<String, List<String>>.from(sideSelectedMap),
      });
    }


  }

  // Tap-outside barrier
  barrier = OverlayEntry(
    builder: (_) => GestureDetector(
      onTap: removeAll,
      behavior: HitTestBehavior.translucent,
      child: Container(color: Colors.transparent),
    ),
  );
  overlay.insert(barrier);

  void showSideDropdown(String item) {
    if (currentSideDropdownItem == item && (sideEntry?.mounted ?? false)) {
      developer.log('Side dropdown already open for $item, skipping');
      return;
    }

    final subOpts = sideOptionsMap[item] ?? [];
    developer.log('Showing side dropdown for $item with sub-options: $subOpts');
    if (subOpts.isEmpty || !mainSelected.contains(item)) {
      if (sideEntry?.mounted ?? false) {
        sideEntry?.remove();
        sideEntry = null;
        developer.log('No sub-options or item not selected, closing side dropdown');
      }
      currentSideDropdownItem = null;
      return;
    }

    currentSideDropdownItem = item;
    if (sideEntry?.mounted ?? false) {
      sideEntry?.remove();
      sideEntry = null;
    }

    sideEntry = OverlayEntry(
      builder: (_) {
        double sideLeft = offset.dx + size.width + (MediaQuery.of(context).size.width * 0.07);
        if (sideLeft + 150 > MediaQuery.of(context).size.width) sideLeft = offset.dx - 150 - 8;
        double maxHeight = MediaQuery.of(context).size.height - offset.dy - size.height - 16;
        return Positioned(
          left: sideLeft,
          top: offset.dy + size.height,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(6),
            child: IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.dialogBorder),
                ),
                child: StatefulBuilder(
                  builder: (ctxSide, setStateSide) {
                    final selectedList = sideSelectedMap[item] ?? [];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: subOpts.map((subItem) {
                        final isSubChecked = selectedList.contains(subItem);
                        return CheckboxListTile(
                          value: isSubChecked,
                          title: Text(subItem, style: FFontStyles.filters(14)),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: AppColors.primary,
                          fillColor: WidgetStateProperty.resolveWith((_) => AppColors.checkboxColor),
                          side: WidgetStateBorderSide.resolveWith((_) => BorderSide.none),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          onChanged: (checked) {
                            setStateSide(() {
                              if (singleSideSelection) {
                                selectedList.clear();
                                if (checked == true) selectedList.add(subItem);
                              } else {
                                if (checked == true) {
                                  selectedList.add(subItem);
                                } else {
                                  selectedList.remove(subItem);
                                }
                              }
                              sideSelectedMap[item] = List.from(selectedList);
                            });
                            mainSetState(() {});
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(sideEntry!);
  }

  mainEntry = OverlayEntry(
    builder: (_) {
      double leftPos = offset.dx;
      final screenWidth = MediaQuery.of(context).size.width;
      const estimatedWidth = 200;
      if (leftPos + estimatedWidth > screenWidth) leftPos = screenWidth - estimatedWidth - 8;
      if (leftPos < 8) leftPos = 8;

      return Positioned(
        left: leftPos,
        top: offset.dy + size.height,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(6),
          child: IntrinsicWidth(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.dialogBorder),
              ),
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (ctx, setState) {
                    mainSetState = setState;
                    // Show side dropdown for selected category on initial render
                    if (enableSideDropdown && mainSelected.isNotEmpty && sideOptionsMap.containsKey(mainSelected.first)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (currentSideDropdownItem != mainSelected.first) {
                          showSideDropdown(mainSelected.first);
                        }
                      });
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((item) {
                        final isChecked = mainSelected.contains(item);
                        return CheckboxListTile(
                          value: isChecked,
                          title: Text(item, style: FFontStyles.filters(14)),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: AppColors.primary,
                          fillColor: WidgetStateProperty.resolveWith((_) => AppColors.checkboxColor),
                          side: WidgetStateBorderSide.resolveWith((_) => BorderSide.none),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          onChanged: (checked) {
                            setState(() {
                              if (singleSelection) {
                                mainSelected.clear();
                                sideSelectedMap.clear();
                                if (checked == true) mainSelected.add(item);
                              } else {
                                if (checked == true) {
                                  mainSelected.add(item);
                                } else {
                                  mainSelected.remove(item);
                                  sideSelectedMap.remove(item);
                                }
                              }
                              onSelected(mainSelected);
                            });

                            if (!enableSideDropdown) return;

                            if (checked == true) {
                              // Only show if user selected it
                              showSideDropdown(item);
                            } else {
                              // Close only if that category’s side dropdown was open
                              if (currentSideDropdownItem == item) {
                                sideEntry?.remove();
                                sideEntry = null;
                                currentSideDropdownItem = null;
                              }
                            }
                          },

                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(mainEntry);
  return completer.future;
}
