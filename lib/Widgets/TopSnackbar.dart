import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';

class TopSnackbar {
  static OverlayEntry? _currentSnackbar;
  static bool _isShowing = false;
  static final bool _isError = false; // just bool
  static DateTime? _lastShown;

  /// Show a top snackbar
  static void show(
      BuildContext context, {
        required String message,
        bool isError = false, // pass error flag instead
        Color? backgroundColor, // optional, assign below
        Duration duration = const Duration(seconds: 2),
      }) {
    // assign backgroundColor based on isError if not provided
    backgroundColor ??= isError ? AppColors.logoutColor : AppColors.myOrdersApproved;

    // debounce check
    final now = DateTime.now();
    if (_lastShown != null && now.difference(_lastShown!).inSeconds < 3) return;
    _lastShown = now;

    _currentSnackbar?.remove();

    _currentSnackbar = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentSnackbar!);

    _isShowing = true;

    Future.delayed(duration, () {
      _currentSnackbar?.remove();
      _currentSnackbar = null;
      _isShowing = false;
    });
  }
}
