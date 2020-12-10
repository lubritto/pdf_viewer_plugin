//package com.example.pdfviewerpluginexample;
//
//import android.os.Bundle;
//
//import com.example.pdfviewerplugin.PdfViewerPlugin;
//
//import io.flutter.app.FlutterActivity;
//import io.flutter.plugins.pathprovider.PathProviderPlugin;
//
//public class EmbedderV1Activity extends FlutterActivity {
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        PathProviderPlugin.registerWith(registrarFor("io.flutter.plugins.flutter.io/path_provider"));
//        PdfViewerPlugin.registerWith(registry.registrarFor("com.example.pdfviewerplugin.PdfViewerPlugin"));
//    }
//}