package com.example.pdfviewerplugin;

import android.content.Context;
import android.view.View;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;


public class PdfViewerFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final View containerView;

    PdfViewerFactory(BinaryMessenger messenger, View containerView) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.containerView = containerView;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new PdfViewer(context, messenger, id, params, containerView);
    }
}