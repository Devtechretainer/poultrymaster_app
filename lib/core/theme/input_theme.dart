import 'package:flutter/material.dart';

/// Input field theme matching the modern form design
class InputTheme {
  /// Standard input decoration for text fields
  static InputDecoration standardDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }

  /// Dropdown decoration
  static InputDecoration dropdownDecoration({
    required String label,
    String? hint,
  }) {
    return standardDecoration(
      label: label,
      hint: hint,
      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
    );
  }

  /// Date picker decoration
  static InputDecoration dateDecoration({
    required String label,
    String? hint,
  }) {
    return standardDecoration(
      label: label,
      hint: hint,
      suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
    );
  }

  /// Text area decoration for multi-line inputs
  static InputDecoration textAreaDecoration({
    required String label,
    String? hint,
  }) {
    return standardDecoration(
      label: label,
      hint: hint,
    ).copyWith(
      contentPadding: const EdgeInsets.all(16),
      alignLabelWithHint: true,
    );
  }
}

/// Standard button style for form actions
class FormButtonStyle {
  static ButtonStyle primary() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    );
  }

  static ButtonStyle secondary() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[100],
      foregroundColor: Colors.grey[800],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    );
  }
}


