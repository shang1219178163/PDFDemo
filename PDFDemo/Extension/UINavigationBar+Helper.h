//
//  UINavigationBar+Helper.h
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (Appearance)

- (void)setColor:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor shadowColor:(nullable UIColor *)shadowColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
