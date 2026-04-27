import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class AppTextStyles {

  static final TextStyle display = GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle displayMedium = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle large = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle largeBold = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle medium = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle mediumBold = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle small = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle smallBold = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle buttonTitle = GoogleFonts.cairo(
    fontSize: 45,
    fontWeight: FontWeight.normal,
    color: AppColors.surface
  );
}