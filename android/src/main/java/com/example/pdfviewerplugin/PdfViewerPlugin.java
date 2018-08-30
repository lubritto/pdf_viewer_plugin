package com.example.pdfviewerplugin;

import com.github.barteksc.pdfviewer.PDFView;

import android.graphics.Point;
import android.view.Display;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import java.io.File;
import java.util.ArrayList;
import android.content.Context;
import android.app.Activity;
import android.net.Uri;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * PdfViewerPlugin
 */
public class PdfViewerPlugin implements MethodCallHandler {
  /**
   * Plugin registration.
   */

  static MethodChannel channel;
  private Activity activity;
  private Result result;
  private PDFView pdfView;

  private PdfViewerPlugin(Activity activity) {
    this.activity = activity;
  }

  private ArrayList<String> docPaths = new ArrayList<>();

  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "pdf_viewer_plugin");
    PdfViewerPlugin plugin = new PdfViewerPlugin(registrar.activity());
    channel.setMethodCallHandler(plugin);
  }

  private FrameLayout.LayoutParams buildLayoutParams(MethodCall call) {
    Map<String, Number> rc = call.argument("rect");
    FrameLayout.LayoutParams params;
    if (rc != null) {
      params = new FrameLayout.LayoutParams(
              dp2px(activity, rc.get("width").intValue()), dp2px(activity, rc.get("height").intValue()));
      params.setMargins(dp2px(activity, rc.get("left").intValue()), dp2px(activity, rc.get("top").intValue()),
              0, 0);
    } else {
      Display display = activity.getWindowManager().getDefaultDisplay();
      Point size = new Point();
      display.getSize(size);
      int width = size.x;
      int height = size.y;
      params = new FrameLayout.LayoutParams(width, height);
    }

    return params;
  }

  private int dp2px(Context context, float dp) {
    final float scale = context.getResources().getDisplayMetrics().density;
    return (int) (dp * scale + 0.5f);
  }

  private void close(MethodCall call, MethodChannel.Result result) {
    if (pdfView != null) {
      ViewGroup vg = (ViewGroup) (pdfView.getParent());
      vg.removeView(pdfView);
    }

    if (result != null) {
      result.success(null);
    }

    channel.invokeMethod("onDestroy", null);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPdfViewer")) {

      pdfView = new PDFView(activity, null);

      FrameLayout.LayoutParams params = buildLayoutParams(call);
      activity.addContentView(pdfView, params);

      String path = call.argument("path").toString();

      File file = new File(path);

      pdfView.fromFile(file)
              .enableSwipe(true) // allows to block changing pages using swipe
              .swipeHorizontal(false)
              .enableDoubletap(true)
              .defaultPage(0)
              .load();

      result.success(null);
    } else if (call.method.equals("close")) {
      close(call, result);
        pdfView = null;
    } else {
      result.notImplemented();
    }
  }
}
