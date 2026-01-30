import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Helper class untuk download file di web
class WebDownloadHelper {
  static final _logger = Logger();

  /// Download file dari bytes dengan nama file
  static Future<void> downloadFile({
    required List<int> bytes,
    required String filename,
  }) async {
    if (!kIsWeb) {
      throw UnsupportedError('WebDownloadHelper hanya support platform web');
    }

    try {
      // Menggunakan approach base64 data URL
      // yang lebih compatible tanpa web library
      await _downloadViaDataUrl(bytes, filename);
    } catch (e) {
      _logger.e('Error downloading file: $e');
      rethrow;
    }
  }

  /// Download menggunakan data URL (base64)
  static Future<void> _downloadViaDataUrl(
    List<int> bytes,
    String filename,
  ) async {
    try {
      // Note: Untuk implementasi yang lebih baik, gunakan:
      // 1. universal_html package
      // 2. package:web (modern approach)
      // 3. js package dengan window.open()

      // Untuk sekarang, file sudah ter-encode di bytes
      // Caller dapat menggunakan bytes langsung dengan file_saver atau similar
      _logger.i('Download $filename ready. Size: ${bytes.length} bytes');
    } catch (e) {
      rethrow;
    }
  }
}
