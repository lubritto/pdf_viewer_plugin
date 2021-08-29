#import "PdfViewerPlugin.h"
#import "PdfView.h"

@implementation PdfViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    PdfViewFactory* pdfViewFactory = [[PdfViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:pdfViewFactory withId:@"pdf_viewer_plugin"];
}

@end
