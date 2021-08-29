import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_viewer_plugin/src/pdf_viewer_method_channel.dart';

import '../../pdf_viewer_plugin.dart';

class CupertinoPdfViewer implements PdfViewerPlatform {
  @override
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    return UiKitView(
      viewType: 'pdf_viewer_plugin',
      onPlatformViewCreated: (int id) {},
      gestureRecognizers: gestureRecognizers,
      creationParams:
          MethodChannelPdfViewerPlatform.creationParamsToMap(creationParams!),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
