package com.example.pdfviewerplugin;

import com.github.barteksc.pdfviewer.PDFView;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.view.View;

import java.io.File;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.platform.PlatformView;

public class PdfViewer implements PlatformView, MethodCallHandler {
    private PDFView pdfView;
    private String filePath;
    private String uri;
    private int spacing = 0;
    private String bgColorString = "#000000";
    private boolean fitEachPage = true;
    private PDFView.Configurator configurator;

    PdfViewer(Context context, BinaryMessenger messenger, int id, Map<String, Object> args) {
        MethodChannel methodChannel = new MethodChannel(messenger, "pdf_viewer_plugin_" + id);
        methodChannel.setMethodCallHandler(this);

        pdfView = new PDFView(context, null);
        if (args.containsKey("backgroundColor") && args.get("backgroundColor") != null) {
            bgColorString = (String) args.get("backgroundColor");
        }
        pdfView.setBackgroundColor(Color.parseColor(bgColorString));

        if (args.containsKey("filePath") && args.get("filePath") != null) {
            filePath = (String) args.get("filePath");
            configurator = pdfView.fromFile(new File(filePath));
        }

//        if (args.containsKey("uri") && args.get("uri") != null) {
//            uri = (String) args.get("uri");
//            configurator = pdfView.fromUri(Uri.parse(uri));
//        }

        if (args.containsKey("spacing") && args.get("spacing") != null) {
            spacing = (int) args.get("spacing");
        }
        if (args.containsKey("fitEachPage") && args.get("fitEachPage") != null) {
            fitEachPage = (boolean) args.get("fitEachPage");
        }
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
        configurator
                .enableSwipe(true) // allows to block changing pages using swipe
                .swipeHorizontal(false)
                .enableDoubletap(true)
                .spacing(spacing)
                .fitEachPage(true)
                .defaultPage(0)
                .load();
    }

    @Override
    public View getView() {
        return pdfView;
    }

    @Override
    public void dispose() {
    }
}
