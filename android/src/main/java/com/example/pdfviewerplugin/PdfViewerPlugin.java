package com.example.pdfviewerplugin;

import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PdfViewerPlugin {
  public static void registerWith(Registrar registrar) {
    registrar
            .platformViewRegistry()
            .registerViewFactory(
                    "pdf_viewer_plugin", new PdfViewerFactory(registrar.messenger()));
  }
}
