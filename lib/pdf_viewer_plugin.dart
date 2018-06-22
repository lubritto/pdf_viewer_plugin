import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class PdfViewerPlugin {
  static const MethodChannel _channel =
      const MethodChannel('pdf_viewer_plugin');

  static Future<String> getPdfViewer(String path, double top, double width, double height) async {
    final String version = await _channel.invokeMethod('getPdfViewer', <String, dynamic>{
        'path': path,
        'rect': {
          "left": 0,
          "top": top,
          "width": width,
          "height": height
        }
      });
    return version;
  }

  /// Will trigger the [onDestroy] event
  static Future close() => _channel.invokeMethod("close");
}
