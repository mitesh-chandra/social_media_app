import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showMessageDialog({
  required BuildContext context,
  required String message,
  bool isError = true,
  Duration autoCloseDuration = const Duration(seconds: 3),
}) async {
  Timer? autoCloseTimer;

  autoCloseTimer = Timer(autoCloseDuration, () {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  });

  await showDialog(
    context: context,
    barrierDismissible: false, // prevent tap outside to close
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                size: 48,
                color: isError ? Colors.redAccent : Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                isError ? "Error" : "Success",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isError ? Colors.redAccent : Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  autoCloseTimer?.cancel();
                  GoRouter.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isError ? Colors.redAccent : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  autoCloseTimer.cancel(); // ensure timer is cancelled when dialog is closed manually
}
