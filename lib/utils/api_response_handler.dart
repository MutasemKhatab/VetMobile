import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vet/utils/error_parser.dart';

class ApiResponseHandler {
  /// Handles API response and shows appropriate SnackBar.
  /// Returns true if response is successful, false otherwise.
  static bool handleResponse({
    required http.Response response,
    required BuildContext context,
    String? successMessage,
    bool showSuccessMessage = true,
  }) {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    if (isSuccess && showSuccessMessage && successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } else if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorParser.parseErrorResponse(response.body))),
      );
    }

    return isSuccess;
  }

  /// Shows an error message in a SnackBar for exception handling
  static void handleException({
    required BuildContext context,
    required dynamic exception,
    String? prefix,
  }) {
    final message =
        prefix != null ? '$prefix: $exception' : exception.toString();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
