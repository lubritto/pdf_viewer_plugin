import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/src/android_viewers/android_pdf_viewer.dart';
import 'package:pdf_viewer_plugin/src/ios_viewers/cupertino_pfd_viewer.dart';

export 'package:pdf_viewer_plugin/src/android_viewers/surface_android_pdf_viewer.dart';

typedef void PdfViewerCreatedCallback();

class CreationParams {
  CreationParams({
    this.path,
  });

  final String? path;

  @override
  String toString() {
    return '$runtimeType(path: $path)';
  }
}

abstract class PdfViewerPlatform {
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  });
}

class PdfView extends StatefulWidget {
  /// Creates a new PdfView.
  const PdfView({
    Key? key,
    required this.path,
    this.gestureRecognizers,
    this.gestureNavigationEnabled = false,
  }) : super(key: key);

  static PdfViewerPlatform? _platform;

  /// Sets a custom [PdfViewerPlatform].
  ///
  /// This property can be set to use a custom platform implementation for PdfViews.
  ///
  /// Setting `platform` doesn't affect [PdfView]s that were already created.
  ///
  /// The default value is [AndroidPdfViewer] on Android and [CupertinoPdfViewer] on iOS.
  static set platform(PdfViewerPlatform? platform) {
    _platform = platform;
  }

  /// The PdfView platform that's used by this PdfView.
  ///
  /// The default value is [AndroidPdfViewer] on Android and [CupertinoPdfViewer] on iOS.
  static PdfViewerPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidPdfViewer();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoPdfViewer();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default PdfView implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform!;
  }

  /// Which gestures should be consumed by the PdfView.
  ///
  /// It is possible for other gesture recognizers to be competing with the Pdf View on pointer
  /// events, e.g if the Pdf View is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The Pdf View will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the Pdf View will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The initial path to load.
  final String path;

  /// A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations.
  ///
  /// This only works on iOS.
  ///
  /// By default `gestureNavigationEnabled` is false.
  final bool gestureNavigationEnabled;

  @override
  State<StatefulWidget> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return PdfView.platform.build(
      context: context,
      gestureRecognizers: widget.gestureRecognizers,
      creationParams: _creationParamsFromWidget(widget),
    );
  }
}

CreationParams _creationParamsFromWidget(PdfView widget) {
  return CreationParams(
    path: widget.path,
  );
}
