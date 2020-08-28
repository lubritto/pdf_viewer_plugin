import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void PdfViewerCreatedCallback();

class PdfViewer extends StatefulWidget {
  final int spacing;
  final String filePath;
  final String uri;
  final String backgroundColor;
  final PdfViewerCreatedCallback onPdfViewerCreated;

  const PdfViewer({
    Key key,
    this.filePath,
    this.spacing,
    this.onPdfViewerCreated,
    this.backgroundColor,
    this.uri,
  }) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'pdf_viewer_plugin',
        creationParams: <String, dynamic>{
          'filePath': widget.filePath,
          'spacing': widget.spacing,
          'backgroundColor': widget.backgroundColor,
          'uri': widget.uri,
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
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
