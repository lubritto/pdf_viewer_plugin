import 'dart:async';

import 'package:flutter/services.dart';

import '../pdf_viewer_plugin.dart';

class MethodChannelPdfViewerPlatform {
  /// Constructs an instance that will listen for pdf views broadcasting to the
  /// given [id]
  MethodChannelPdfViewerPlatform(int id)
      : _channel = MethodChannel('pdf_viewer_plugin_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final MethodChannel _channel;

  Future<bool> _onMethodCall(MethodCall call) async {
    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  /// Converts a [CreationParams] object to a map as expected by `platform_views` channel.
  ///
  /// This is used for the `creationParams` argument of the platform views created by
  /// [AndroidPdfViewerBuilder] and [CupertinoPdfViewerBuilder].
  static Map<String, dynamic> creationParamsToMap(
      CreationParams creationParams) {
    return <String, dynamic>{
      'filePath': creationParams.path,
    };
  }
}
