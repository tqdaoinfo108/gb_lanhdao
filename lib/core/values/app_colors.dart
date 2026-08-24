import 'package:flutter/material.dart';

/// Bảng màu chuẩn toàn app.
/// Tất cả màu sắc PHẢI được lấy từ đây, không hard-code hex trực tiếp vào UI.
class AppColors {
  AppColors._(); // Không cho khởi tạo instance

  // ---------------------------------------------------------------------------
  // Primary
  // ---------------------------------------------------------------------------
  static const Color primaryBlue      = Color(0xFF009947);
  static const Color primaryBlueDark  = Color(0xFF007A39);
  static const Color primaryBlueLight = Color(0xFFE6F5EC);

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------
  static const Color successGreen  = Color(0xFF26A69A);
  static const Color successLight  = Color(0xFFE8F5E9);
  static const Color alertRed      = Color(0xFFE74C3C);
  static const Color alertRedLight = Color(0xFFFDECEA);
  static const Color warningYellow = Color(0xFFF2C94C);
  static const Color warningLight  = Color(0xFFFFFBE6);

  // ---------------------------------------------------------------------------
  // Background & Surface
  // ---------------------------------------------------------------------------
  static const Color neutralBackground = Color(0xFFF5F7FB);
  static const Color cardWhite         = Color(0xFFFFFFFF);
  static const Color divider           = Color(0xFFE5E7EB);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------
  static const Color textPrimary   = Color(0xFF0F1724);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled  = Color(0xFFB0B7C3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Shadow
  // ---------------------------------------------------------------------------
  static BoxShadow get lightShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow get mediumShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.10),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
}
