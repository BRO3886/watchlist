import 'package:flutter/material.dart';
import 'package:watchlist/src/presentation/theme/theme.dart';

SnackBar successSnackbar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: darkGreen,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: Colors.green.shade100,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    duration: const Duration(seconds: 2),
  );
}

SnackBar errorSnackbar(String message) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.red.shade800,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: Colors.red.shade100,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
    elevation: 0,
  );
}
