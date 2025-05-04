import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:vet/main.dart';
import 'package:http_parser/http_parser.dart';

class ImageApiHelper {
  static const String imageApiUrl = "$baseUrl/api/Image";

  /// Uploads an image to the server.
  /// [file] is the image file to upload.
  /// [imageType] specifies the type of image ("vet" or "pfp").
  /// Returns the file path on the server if successful.
  static Future<String> uploadImage(File file, String imageType) async {
    final url = Uri.parse('$imageApiUrl/upload');

    // Validate file type
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null ||
        !['image/jpeg', 'image/png', 'image/gif'].contains(mimeType)) {
      throw Exception(
          'Invalid file type. Only .jpg, .jpeg, .png, and .gif are allowed.');
    }

    // Create multipart request
    final request = http.MultipartRequest('POST', url)
      ..fields['imageType'] = imageType
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType),
      ));

    // Send the request
    final response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return responseBody; // Assuming the server returns the file path in the response
    } else {
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
    }
  }
}
