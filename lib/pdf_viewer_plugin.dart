import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void PdfViewerCreatedCallback();

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    Key key,
    this.filePath,
    this.onPdfViewerCreated,
  }) : super(key: key);

  final String filePath;
  final PdfViewerCreatedCallback onPdfViewerCreated;

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        color: Colors.white,
        child: AndroidView(
          viewType: 'pdf_viewer_plugin',
          creationParams: <String, dynamic>{
            'filePath': widget.filePath,
          },
          creationParamsCodec: StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'pdf_viewer_plugin',
        creationParams: <String, dynamic>{
          'filePath': widget.filePath,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the pdf_viewer plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onPdfViewerCreated == null) {
      return;
    }
    widget.onPdfViewerCreated();
  }
}
