//
//  ILPDFKit.m
//  ILPDFKit-Cordova
//
//  Created by Yauhen Hatsukou on 22.10.14.
//
//

#import "ILPDFKit.h"

@interface ILPDFKit ()

@property (nonatomic, strong) PDFViewController *pdfViewController;
@property (nonatomic, strong) NSString *fileNameToSave;

@end

@implementation ILPDFKit

- (void)present:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        NSString *pdf = [command.arguments objectAtIndex:0];
        NSDictionary *options = [command.arguments objectAtIndex:1];
        
        BOOL useDocumentsFolder = [options[@"useDocumentsFolder"] boolValue];
        if (useDocumentsFolder) {
            pdf = [[self documentsDirectory] stringByAppendingPathComponent:pdf];
        }
        else {
            pdf = [self pdfFilePathWithPath:pdf];
        }
        
        BOOL showSaveButton = [options[@"showSaveButton"] boolValue];
        
        NSString *fileNameToSave = options[@"fileNameToSave"];
        if (fileNameToSave.length == 0) {
            fileNameToSave = [pdf lastPathComponent];
        }
        
        self.fileNameToSave = fileNameToSave;
        
        if (pdf && pdf.length != 0) {
            @try {
                self.pdfViewController = [[PDFViewController alloc] initWithPath:pdf];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to open pdf"]
                                            callbackId:command.callbackId];
                return;
            }
            
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
            
            self.pdfViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onClose:)];
            
            if (showSaveButton) {
                self.pdfViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(onSave:)];
            }
            
            [self.viewController presentViewController:navVC animated:YES completion:^{
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                            callbackId:command.callbackId];
            }];
        }
        else {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to open pdf"]
                                        callbackId:command.callbackId];
        }
    }];
}

- (void)onClose:(id)sender {
    [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSave:(id)sender {
    [self.pdfViewController.document saveFormsToDocumentData:^(BOOL success) {
        
        if(success) {
            [self.pdfViewController.document writeToFile:self.fileNameToSave];
            [self sendEventWithJSON:@{@"type" : @"savePdf", @"success" : @YES, @"savedPath" : [[self documentsDirectory] stringByAppendingPathComponent:self.fileNameToSave]}];
        }
        else {
            [self sendEventWithJSON:@{@"type" : @"savePdf", @"success" : @NO}];
        }
    }];
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

- (BOOL)sendEventWithJSON:(id)JSON {
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        JSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:JSON options:0 error:NULL] encoding:NSUTF8StringEncoding];
    }
    NSString *script = [NSString stringWithFormat:@"ILPDFKit.dispatchEvent(%@)", JSON];
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:script];
    return [result length]? [result boolValue]: YES;
}

- (NSString *)documentsDirectory {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    return documentsDir;
}

@end
