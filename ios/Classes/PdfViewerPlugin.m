@import UIKit;

#import "PdfViewerPlugin.h"

@interface PdfViewerPlugin ()
@end

@implementation PdfViewerPlugin{
    FlutterResult _result;
    UIViewController *_viewController;
    UIWebView *_webView;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pdf_viewer_plugin"
                                     binaryMessenger:[registrar messenger]];
    
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    PdfViewerPlugin *instance = [[PdfViewerPlugin alloc] initWithViewController:viewController];
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (CGRect)parseRect:(NSDictionary *)rect {
    return CGRectMake([[rect valueForKey:@"left"] doubleValue],
                      [[rect valueForKey:@"top"] doubleValue],
                      [[rect valueForKey:@"width"] doubleValue],
                      [[rect valueForKey:@"height"] doubleValue]);
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
    
    if ([@"getPdfViewer" isEqualToString:call.method]) {
        
        NSDictionary *rect = call.arguments[@"rect"];
        NSString *path = call.arguments[@"path"];
        
        CGRect rc = [self parseRect:rect];
        
        if (_webView == nil){
            _webView = [[UIWebView alloc] initWithFrame:rc];
            _webView.scalesPageToFit = true;
            
            NSURL *targetURL = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [_webView loadRequest:request];
            
            [_viewController.view addSubview:_webView];

            result(nil);
        }
        
    }
    else if ([@"close" isEqualToString:call.method]) {
        [self closeWebView];
        result(nil);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)closeWebView {
    if (_webView != nil) {
        [_webView stopLoading];
        [_webView removeFromSuperview];
        _webView = nil;
    }
}


@end
