//
//  PDFDocument+Helper.h
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFDocument (Helper)

+ (instancetype)docForResource:(nullable NSString *)name ofType:(nullable NSString *)ext;

@end

NS_ASSUME_NONNULL_END
