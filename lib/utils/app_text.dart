import 'package:flutter/material.dart';

import 'app_colors.dart';

// Manrope is a variable font, so the weight is set in fontVariations too.
// letterSpacing is 0 because the material theme adds some by default.
class AppText {
  static const title = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
    letterSpacing: 0,
    color: AppColors.brand,
  );

  static const hint = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0,
    color: AppColors.grey,
    height: 1.4,
  );

  static const label = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0,
    color: AppColors.grey,
    height: 1.4,
  );

  static const value = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
    color: AppColors.brand,
    letterSpacing: 0,
    height: 1.4,
  );

  static const menuItem = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: 0,
    color: AppColors.black,
    height: 1.4,
  );

  static const divider = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    color: AppColors.grey,
    height: 1.4,
  );

  static const info = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    color: AppColors.grey,
    height: 16 / 12,
  );

  static const consent = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    color: AppColors.black,
    height: 16 / 12,
  );

  static const link = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    letterSpacing: 0,
    color: AppColors.brand,
    height: 16 / 12,
  );

  static const button = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 0,
    color: AppColors.white,
  );
}
