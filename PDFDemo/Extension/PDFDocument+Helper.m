//
//  PDFDocument+Helper.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "PDFDocument+Helper.h"

@implementation PDFDocument (Helper)

+ (instancetype)docForResource:(nullable NSString *)name ofType:(nullable NSString *)ext {
    NSString *path = [NSBundle.mainBundle pathForResource:name ofType:ext];
    if (!path) {
        return nil;
    }
    if (![NSURL fileURLWithPath:path]) {
        return nil;
    }
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    PDFDocument *doc = [[PDFDocument alloc] initWithURL:fileUrl];
    return doc;
}

@end
