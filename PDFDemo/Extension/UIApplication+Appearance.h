//
//  UIApplication+Appearance.h
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Appearance)

+ (void)setupAppearance:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor;

@end


@interface UINavigationBarAppearance (Ext)

+ (instancetype)create:(UIColor *)tintColor
          barTintColor:(UIColor *)barTintColor
           shadowColor:(nullable UIColor *)shadowColor
                  font:(nullable UIFont *)font;
@end


@interface UITabBarAppearance (Ext)

+ (instancetype)create:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor font:(nullable UIFont *)font;

@end




@interface UITabBarItemAppearance (Ext)

+ (instancetype)createWithNormal:(NSDictionary<NSAttributedStringKey, id> *)normalAttrs selected:(NSDictionary<NSAttributedStringKey, id> *)selectedAttrs;

@end

NS_ASSUME_NONNULL_END
