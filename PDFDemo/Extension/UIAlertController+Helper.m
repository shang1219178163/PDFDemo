//
//  UIAlertController+Helper.m
//  ProductTemplet
//
//  Created by Bin Shang on 2019/1/17.
//  Copyright © 2019 BN. All rights reserved.
//

#import "UIAlertController+Helper.h"

/// UIAlertController标题富文本key
NSString * const kAlertVCTitle = @"attributedTitle";
/// UIAlertController信息富文本key
NSString * const kAlertVCMessage = @"attributedMessage";
/// UIAlertController按钮颜色key
NSString * const kAlertActionColor = @"titleTextColor";

NSString * const kAlertContentViewController = @"contentViewController";


@implementation UIAlertController (Helper)

- (UIAlertController * _Nonnull (^)(NSArray<NSString *> * _Nonnull, void (^)(UIAlertAction *action)))addAction{
    return ^(NSArray<NSString *> *titles, void(^handler)(UIAlertAction *action)){
        [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertActionStyle style = [title isEqualToString:@"取消"] ? UIAlertActionStyleCancel : UIAlertActionStyleDefault;
            [self addAction:[UIAlertAction actionWithTitle:title style:style handler:handler]];
        }];
        return self;
    };
}

- (UIAlertController * _Nonnull (^)(NSArray<NSString *> * _Nonnull, void (^ _Nonnull)(UITextField *textField)))addTextField{
    NSParameterAssert(self.preferredStyle == UIAlertControllerStyleAlert);
    if (self.preferredStyle != UIAlertControllerStyleAlert) {
        return ^(NSArray<NSString *> *placeholders, void(^handler)(UITextField *action)){
            return self;
        };
    }

    return ^(NSArray<NSString *> *placeholders, void(^handler)(UITextField *action)){
        [placeholders enumerateObjectsUsingBlock:^(NSString * _Nonnull placeholder, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = placeholder;
                if (handler) {
                    handler(textField);
                }
            }];
        }];
        return self;
    };
}

- (UIAlertController * _Nonnull (^)(BOOL, void (^ _Nullable)(void)))present{
    return ^(BOOL animated, void(^completion)(void)){
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow ? : UIApplication.sharedApplication.windows.firstObject;
        if (self.preferredStyle == UIAlertControllerStyleAlert) {
            if (self.actions.count == 0) {
                [keyWindow.rootViewController presentViewController:self animated:animated completion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:animated completion:completion];
                    });
                }];
            } else {
                [keyWindow.rootViewController presentViewController:self animated:animated completion:completion];
            }
        }
        return self;
    };
}


- (instancetype)addActionTitles:(NSArray<NSString *> *)titles handler:(void(^)(UIAlertController *vc, UIAlertAction *action))handler {
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertActionStyle style = [title isEqualToString:@"取消"] ? UIAlertActionStyleCancel : UIAlertActionStyleDefault;
        [self addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(self, action);
            }
        }]];
    }];
    return self;
}

- (instancetype)addTextFieldPlaceholders:(NSArray<NSString *> *)placeholders handler:(void(^)(UITextField *textField))handler {
    NSParameterAssert(self.preferredStyle == UIAlertControllerStyleAlert);
    if (self.preferredStyle != UIAlertControllerStyleAlert) {
        return self;
    }

    [placeholders enumerateObjectsUsingBlock:^(NSString * _Nonnull placeholder, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            if (handler) {
                handler(textField);
            }
        }];
    }];
    return self;
}

+ (instancetype)createAlertTitle:(NSString * _Nullable)title
                         message:(NSString *_Nullable)message
                    actionTitles:(NSArray *_Nullable)actionTitles
                         handler:(void(^_Nullable)(UIAlertController *vc, UIAlertAction *action))handler{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addActionTitles:actionTitles handler:handler];
    return alertVC;
}



@end
