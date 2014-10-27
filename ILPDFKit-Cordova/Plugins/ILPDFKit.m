//
//  ILPDFKit.m
//  ILPDFKit-Cordova
//
//  Created by Yauhen Hatsukou on 22.10.14.
//
//

#import "ILPDFKit.h"
#import "PDFFormContainer.h"

@interface ILPDFKit ()

@property (nonatomic, strong) PDFViewController *pdfViewController;
@property (nonatomic, strong) NSString *fileNameToSave;
@property (nonatomic, assign) BOOL autoSave;
@property (nonatomic, assign) BOOL isAnyFormChanged;
@property (nonatomic, assign) BOOL askToSaveBeforeClose;

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
        
        self.autoSave = [options[@"autoSave"] boolValue];
        
        self.askToSaveBeforeClose = [options[@"askToSaveBeforeClose"] boolValue];
        self.isAnyFormChanged = NO;
        
        if (pdf && pdf.length != 0) {
            @try {
                self.pdfViewController = [[PDFViewController alloc] initWithPath:pdf];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(formValueChanged:) name:@"ILPDFKitFormValueChangedNotitfication" object:nil];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILPDFKitFormValueChangedNotitfication" object:nil];
}

- (void)onClose:(id)sender {
    if (self.isAnyFormChanged && self.askToSaveBeforeClose) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"You have made changes to the form that have not been saved. Do you really want to quit?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
        [alert show];
    }
    else {
        [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
    }
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


- (void)formValueChanged:(NSNotification *)notification {
    self.isAnyFormChanged = YES;
    if (self.autoSave) {
        [self onSave:nil];
        self.isAnyFormChanged = NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
