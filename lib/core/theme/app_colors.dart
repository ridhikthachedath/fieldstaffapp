import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF1F7F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryDark = Color(0xFF042222);
  static const Color primaryGreen = Color(0xFF03624C);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF7D7D7D);
  static const Color placeholder = Color(0xFF828282);
  static const Color border = Color(0xFFE0E0E0);
  static const Color fieldBorder = Color(0xFFF0F0F0);
  static const Color leaveTypeAccent = Color(0xFFD4C200);
  static const Color attendanceActiveBorder = Color(0xFF8E35FF);
  static const Color pending = Color(0xFFFFC107);
  static const Color approved = Color(0xFF03624C);
  static const Color rejected = Color(0xFFD32F2F);
  static const Color loginButton = Color(0x33000000);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF042222), Color(0xFF03624C)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment(-0.8, -0.5),
    end: Alignment(1.0, 0.8),
    colors: [Color(0xFF042222), Color(0xFF03624C)],
  );

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
}
