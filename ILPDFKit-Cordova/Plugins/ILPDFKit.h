//
//  ILPDFKit.h
//  ILPDFKit-Cordova
//
//  Created by Yauhen Hatsukou on 22.10.14.
//
//

#import <Cordova/CDV.h>

#import "PDF.h"

@interface ILPDFKit : CDVPlugin

- (void)openPdfFromResource:(CDVInvokedUrlCommand *)command;
- (void)openPdfFromPath:(CDVInvokedUrlCommand *)command;

@property (nonatomic, strong) PDFViewController *pdfViewController;

@end
