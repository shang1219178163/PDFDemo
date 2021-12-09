//
//  UINavigationBar+Helper.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "UINavigationBar+Helper.h"
#import "UIImage+Helper.h"
#import "UIApplication+Appearance.h"

@implementation UINavigationBar (Appearance)

- (void)setColor:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor shadowColor:(nullable UIColor *)shadowColor{
    
    [self setBackgroundImage:[UIImage imageWithColor:barTintColor] forBarMetrics:UIBarMetricsDefault];
    
    self.barTintColor = barTintColor;
    self.tintColor = tintColor;
    self.titleTextAttributes = @{NSForegroundColorAttributeName: tintColor,};
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [UINavigationBarAppearance create:tintColor barTintColor:barTintColor shadowColor:shadowColor font:nil];
        self.standardAppearance = barAppearance;
        self.scrollEdgeAppearance = barAppearance;
    }
}


@end
