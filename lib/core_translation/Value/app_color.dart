import 'package:flutter/material.dart';

/// The single source of colour for the app.
///
/// Nothing else should write a raw `Color(0xFF...)`; add it here instead, so a
/// palette change is one edit rather than a search across every screen.
class AppColor {
  const AppColor._();

  /// Brand colour. Everything else in this file is either derived from it or
  /// semantic (success / danger / warning).
  static const Color primary = Color(0xFF500EEB);

  /// Pressed states and text that sits on a light tint.
  static const Color primaryDark = Color(0xFF480CD3);

  /// Surfaces behind primary content — avatars, chips, empty states.
  static const Color primaryLight = Color(0xFF8456F1);

  static const Color success = Color(0xFF6126ed);
  static const Color successLight = Color(0xFFECFDF5);

  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEF2F2);

  static const Color warning = Color(0xFFD97706);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF966EF3);
  static const Color textDisabled = Color(0xFFDCCEFB);
}
