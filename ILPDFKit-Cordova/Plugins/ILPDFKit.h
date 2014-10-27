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

- (void)present:(CDVInvokedUrlCommand *)command;
- (void)setFormValue:(CDVInvokedUrlCommand *)command;
- (void)getFormValue:(CDVInvokedUrlCommand *)command;

@end
