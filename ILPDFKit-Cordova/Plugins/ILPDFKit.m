//
//  ILPDFKit.m
//  ILPDFKit-Cordova
//
//  Created by Yauhen Hatsukou on 22.10.14.
//
//

#import "ILPDFKit.h"

@implementation ILPDFKit

- (void)openPdfFromResource:(CDVInvokedUrlCommand *)command {

    NSString *pdf = [command.arguments objectAtIndex:0];
    
    if (pdf && pdf.length != 0) {
        @try {
            self.pdfViewController = [[PDFViewController alloc] initWithResource:pdf];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                        callbackId:command.callbackId];
            return;
        }
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
        
        self.pdfViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onClose:)];
        
        [self.viewController presentViewController:navVC animated:YES completion:^{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                        callbackId:command.callbackId];
        }];
    }
    else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    }
}

- (void)openPdfFromPath:(CDVInvokedUrlCommand *)command {
    
    NSString *pdf = [command.arguments objectAtIndex:0];
    pdf = [self pdfFilePathWithPath:pdf];
    
    if (pdf && pdf.length != 0) {
        @try {
            self.pdfViewController = [[PDFViewController alloc] initWithPath:pdf];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                        callbackId:command.callbackId];
            return;
        }
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
        
        self.pdfViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onClose:)];
        
        [self.viewController presentViewController:navVC animated:YES completion:^{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                        callbackId:command.callbackId];
        }];
    }
    else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    }
}

- (void)onClose:(id)sender {
    [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)pdfFilePathWithPath:(NSString *)path {
    if (path) {
        path = [path stringByExpandingTildeInPath];
        if (![path isAbsolutePath]) {
            path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"] stringByAppendingPathComponent:path];
        }
        return path;
    }
    return nil;
}

@end
