import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer_plugin/src/android_pdf_viewer.dart';
import 'package:pdf_viewer_plugin/src/cupertino_pfd_viewer.dart';
import 'package:pdf_viewer_plugin/src/pdf_viewer_method_channel.dart';

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

class SurfaceAndroidPdfViewer extends AndroidPdfViewer {
  @override
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    return PlatformViewLink(
      viewType: 'pdf_viewer_plugin',
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: 'pdf_viewer_plugin',
          layoutDirection: TextDirection.rtl,
          creationParams: MethodChannelPdfViewerPlatform.creationParamsToMap(
            creationParams!,
          ),
          creationParamsCodec: const StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((int id) {})
          ..create();
      },
    );
  }
}

class PdfView extends StatefulWidget {
  /// Creates a new web view.
  const PdfView({
    Key? key,
    this.path,
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

  /// The WebView platform that's used by this WebView.
  ///
  /// The default value is [AndroidPdfViewer] on Android and [CupertinoPdfViewer] on iOS.
  static PdfViewerPlatform? get platform {
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
              "Trying to use the default webview implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform;
  }

  /// Which gestures should be consumed by the web view.
  ///
  /// It is possible for other gesture recognizers to be competing with the web view on pointer
  /// events, e.g if the web view is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The web view will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the web view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The initial path to load.
  final String? path;

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
    return PdfView.platform!.build(
      context: context,
      gestureRecognizers: widget.gestureRecognizers,
      creationParams: _creationParamsfromWidget(widget),
    );
  }
}

CreationParams _creationParamsfromWidget(PdfView widget) {
  return CreationParams(
    path: widget.path,
  );
}
