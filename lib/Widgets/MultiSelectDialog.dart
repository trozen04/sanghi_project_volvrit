import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

Future<dynamic> showMultiSelectDropdown({
  required BuildContext context,
  required GlobalKey key,
  required String title,
  required List<String> options,                     // main dropdown options
  dynamic initiallySelected,                         // List<String> or Map<String,List<String>>
  required Function(List<String>) onSelected,
  bool enableSideDropdown = false,
  bool singleSelection = false,
  Map<String, List<String>> sideOptionsMap = const {}, // per-main-item sub-options
}) async {
  final List<String> mainSelected = initiallySelected is Map
      ? List<String>.from(initiallySelected['main'] ?? [])
      : List<String>.from(initiallySelected ?? []);
  final Map<String, List<String>> sideSelectedMap = initiallySelected is Map
      ? Map<String, List<String>>.from(initiallySelected['side'] ?? {})
      : {};

  final renderBox = key.currentContext!.findRenderObject() as RenderBox;
  final offset = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final overlay = Overlay.of(context);

  late OverlayEntry mainEntry;
  OverlayEntry? sideEntry;
  late OverlayEntry barrier;
  late void Function(void Function()) mainSetState;

  final completer = Completer<dynamic>();

  void removeAll() {
    if (mainEntry.mounted) mainEntry.remove();
    if (sideEntry?.mounted ?? false) sideEntry?.remove();
    if (barrier.mounted) barrier.remove();

    if (enableSideDropdown && sideSelectedMap.isNotEmpty) {
      if (!completer.isCompleted) {
        completer.complete({
          'main': mainSelected,
          'side': sideSelectedMap,
        });
      }
    } else {
      if (!completer.isCompleted) completer.complete(mainSelected);
    }
  }

  // tap-outside barrier
  barrier = OverlayEntry(
    builder: (_) => GestureDetector(
      onTap: removeAll,
      behavior: HitTestBehavior.translucent,
      child: Container(color: Colors.transparent),
    ),
  );
  overlay.insert(barrier);

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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((item) {
                        final isChecked = mainSelected.contains(item);
                        return CheckboxListTile(
                          value: isChecked,
                          title: Text(item, style: FFontStyles.filters(14)),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: AppColors.primary,
                          fillColor: MaterialStateProperty.resolveWith((_) => AppColors.checkboxColor),
                          side: MaterialStateBorderSide.resolveWith((_) => BorderSide.none),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          onChanged: (checked) {
                            setState(() {
                              if (singleSelection) {
                                mainSelected.clear();
                                if (checked == true) mainSelected.add(item);
                              } else {
                                if (checked == true) mainSelected.add(item);
                                else {
                                  mainSelected.remove(item);
                                  sideSelectedMap.remove(item); // clear its sub-options
                                }
                              }
                              onSelected(mainSelected);
                            });

                            if (!enableSideDropdown) return;

                            // get sub-options for this main item
                            final subOpts = sideOptionsMap[item] ?? [];
                            if (subOpts.isEmpty) {
                              sideEntry?.remove();
                              return;
                            }

                            final mainTop = offset.dy + size.height;
                            final mainLeft = offset.dx;
                            final screenW = MediaQuery.of(context).size.width;
                            sideEntry?.remove();

                            sideEntry = OverlayEntry(
                              builder: (_) {
                                double sideLeft = mainLeft + size.width + (screenW * 0.12);
                                if (sideLeft + 150 > screenW) sideLeft = mainLeft - 150 - 8;
                                double maxHeight = MediaQuery.of(context).size.height - mainTop - 16;
                                return Positioned(
                                  left: sideLeft,
                                  top: mainTop,
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
                                                  fillColor: MaterialStateProperty.resolveWith((_) => AppColors.checkboxColor),
                                                  side: MaterialStateBorderSide.resolveWith((_) => BorderSide.none),
                                                  contentPadding: EdgeInsets.zero,
                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  onChanged: (checked) {
                                                    setStateSide(() {
                                                      if (singleSelection) {
                                                        selectedList.clear();
                                                        if (checked == true) selectedList.add(subItem);
                                                      } else {
                                                        if (checked == true) selectedList.add(subItem);
                                                        else selectedList.remove(subItem);
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

