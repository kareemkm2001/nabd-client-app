import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class FileDownloader {
  static Future<void> downloadPdf(String url, String fileName) async {
    try {
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      final dir = await getApplicationDocumentsDirectory();

      final filePath = "${dir.path}/$fileName.pdf";

      await Dio().download(url, filePath);

      print("Downloaded to: $filePath");

      await OpenFile.open(filePath);

    } catch (e) {
      print("مشكلة التحميل: $e");
    }
  }
}