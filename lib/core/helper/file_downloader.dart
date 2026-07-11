import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static Future<void> downloadPdf({
    required String url,
    required String fileName,
    String? token,
  }) async {
    try {
      final dir = await getTemporaryDirectory();

      final filePath = "${dir.path}/$fileName.pdf";

      await Dio().download(
        url,
        filePath,
        options: Options(
          headers: token == null
              ? null
              : {
            "Authorization": "Bearer $token",
          },
        ),
      );

      await OpenFile.open(filePath);
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
}