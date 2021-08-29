package dev.britto.pdf_viewer_plugin;

import com.github.barteksc.pdfviewer.PDFView;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;

import java.io.File;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.platform.PlatformView;

/// Disable the PdfView recycle when onDetachedFromWindow is called, fixing the
/// flutter hot reload.
class CustomPDFView extends PDFView {
    boolean enableRecycle = true;

    public CustomPDFView(Context context, AttributeSet set) {
        super(context, set);
    }

    @Override
    protected void onDetachedFromWindow() {
        Log.i("PdfViewer", "onDetachedFromWindow");
        enableRecycle = false;
        super.onDetachedFromWindow();
        enableRecycle = true;
    }

    @Override
    public void recycle() {
        if (enableRecycle) {
            super.recycle();
        }
    }
}

public class PdfViewer implements PlatformView, MethodCallHandler {
    final MethodChannel methodChannel;
    private PDFView pdfView;
    private String filePath;

    PdfViewer(final Context context,
              MethodChannel methodChannel,
              Map<String, Object> params,
              View containerView) {
//        Log.i("PdfViewer", "init");

        this.methodChannel = methodChannel;
        this.methodChannel.setMethodCallHandler(this);

        if (!params.containsKey("filePath")) {
            return;
        }
        filePath = (String)params.get("filePath");

        pdfView = new CustomPDFView(context, null);
        loadPdfView();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPdfViewer")) {
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void loadPdfView() {
        pdfView.fromFile(new File(filePath))
                .enableSwipe(true) // allows to block changing pages using swipe
                .swipeHorizontal(false)
                .enableDoubletap(true)
                .defaultPage(0)
                .load();
    }

    @Override
    public View getView() {
        return pdfView;
    }

     @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
//         Log.i("PdfViewer", "onFlutterViewAttached");
    }

    @Override
    public void onFlutterViewDetached() {
//        Log.i("PdfViewer", "onFlutterViewDetached");
    }


    @Override
    public void dispose() {
//        Log.i("PdfViewer", "dispose");
        methodChannel.setMethodCallHandler(null);
    }
}
