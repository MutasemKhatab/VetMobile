import 'dart:convert';

class ErrorParser {
  /// Parses an error response body that could be in JSON format
  /// Returns a user-friendly error message
  static String parseErrorResponse(dynamic responseBody) {
    if (responseBody == null) {
      return 'Unknown error occurred';
    }

    try {
      // First try to parse as JSON
      dynamic parsed = json.decode(responseBody);

      // Check if we have an array of errors
      if (parsed is List) {
        if (parsed.isEmpty) {
          return 'Unknown error occurred';
        }

        // Format array of errors into readable messages
        return parsed.map((error) {
          if (error is Map) {
            // Handle error objects with code and description
            if (error.containsKey('code') && error.containsKey('description')) {
              return error['description'];
            }
            // Handle error objects with error and message
            else if (error.containsKey('error')) {
              return error['error'];
            } else if (error.containsKey('message')) {
              return error['message'];
            }
            // Return the whole object as string if no recognized fields
            return error.toString();
          }
          return error.toString();
        }).join('\n');
      }

      // Handle single error object
      if (parsed is Map<String, dynamic>) {
        // Check for common error fields in API responses
        if (parsed.containsKey('error')) {
          return parsed['error'];
        } else if (parsed.containsKey('message')) {
          return parsed['message'];
        } else if (parsed.containsKey('description')) {
          return parsed['description'];
        } else if (parsed.containsKey('code') &&
            parsed.containsKey('description')) {
          return '${parsed['code']}: ${parsed['description']}';
        }

        // If we have the error response but none of the expected fields, convert to string
        return parsed.toString();
      }

      // If not a recognized format, return as string
      return parsed.toString();
    } catch (e) {
      // If it's not valid JSON, return the raw response as string
      return responseBody.toString();
    }
  }
}
