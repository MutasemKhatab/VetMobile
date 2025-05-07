import 'package:flutter/material.dart';
import 'package:vet/utils/app_localizations.dart';

class Validators {
  static String? phoneNumberValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('please_enter_phone_number');
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return context.tr('please_enter_valid_phone_number');
    }
    return null;
  }

  static String? emailValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('please_enter_your_email');
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return context.tr('please_enter_valid_email');
    }
    return null;
  }

  static String? passwordValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('please_enter_password');
    }
    if (value.length < 8) {
      return context.tr('password_length_error');
    }
    return null;
  }

  static String? emptyText(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('field_required');
    }
    return null;
  }

  static String? validateDate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.tr('please_enter_date_of_birth');
    }
    if (DateTime.tryParse(value) == null) {
      return context.tr('please_enter_valid_date');
    }
    return null;
  }

  // Legacy methods for backward compatibility
  static String? phoneNumberValidatorLegacy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? emailValidatorLegacy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? passwordValidatorLegacy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? emptyTextLegacy(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  static String? validateDateLegacy(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date of birth';
    }
    if (DateTime.tryParse(value) == null) {
      return 'Please enter a valid date';
    }
    return null;
  }
}
