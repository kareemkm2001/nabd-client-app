import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showAppSnackBarSuc({
  required BuildContext context,
  required String message,
}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      message: message,
    ),
    displayDuration: const Duration(seconds: 2),
  );
}


void showAppSnackBarError({
  required BuildContext context,
  required String message,
}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
    ),
    displayDuration: const Duration(seconds: 2),
  );
}

void showAppSnackBarInfo({
  required BuildContext context,
  required String message,
}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(
      message: message,
    ),
    displayDuration: const Duration(seconds: 2),
  );
}