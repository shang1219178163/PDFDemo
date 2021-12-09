//
//  UIApplication+Appearance.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "UIApplication+Appearance.h"

@implementation UIApplication (Appearance)

+ (void)setupAppearance:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor {
    UINavigationBar.appearance.tintColor = tintColor;
    UINavigationBar.appearance.barTintColor = barTintColor;

    if (@available(iOS 11.0, *)) {
        [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[UIDocumentBrowserViewController.class]].tintColor = nil;
    }

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [UINavigationBarAppearance create:tintColor barTintColor:barTintColor shadowColor:nil font:[UIFont systemFontOfSize:15]];
        UINavigationBar.appearance.standardAppearance = barAppearance;
        UINavigationBar.appearance.scrollEdgeAppearance = barAppearance;

        UITabBarAppearance *tabBarAppearance = [UITabBarAppearance create:tintColor barTintColor:barTintColor font:nil];
        UITabBar.appearance.standardAppearance = tabBarAppearance;
    }
    
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[UINavigationBar.class]] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[UIImagePickerController.class]] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.blackColor,} forState:UIControlStateNormal];

    
    UIButton.appearance.titleLabel.adjustsFontSizeToFitWidth = true;
    UIButton.appearance.titleLabel.minimumScaleFactor = 1.0;
    UIButton.appearance.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIButton.appearance.exclusiveTouch = true;
    UIButton.appearance.adjustsImageWhenHighlighted = false;
    
    if ([NSClassFromString(@"UICalloutBarButton") isKindOfClass:UIButton.class]) {
        [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    
    UISegmentedControl.appearance.tintColor = tintColor;
    
    UISegmentedControl *segmentedInNavigationBar = [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[UINavigationBar.class]];
    [segmentedInNavigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor,} forState:UIControlStateNormal];
    [segmentedInNavigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: barTintColor,} forState:UIControlStateSelected];

    
    UIScrollView.appearance.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIScrollView.appearance.showsHorizontalScrollIndicator = false;
    UIScrollView.appearance.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UITableView.appearance.tintColor = tintColor;
    UITableView.appearance.separatorInset = UIEdgeInsetsZero;
    UITableView.appearance.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UITableView.appearance.rowHeight = 60;
    UITableView.appearance.backgroundColor = UIColor.groupTableViewBackgroundColor;
    UITableView.appearance.estimatedRowHeight = 0.0;
    UITableView.appearance.estimatedSectionHeaderHeight = 0.0;
    UITableView.appearance.estimatedSectionFooterHeight = 0.0;
    
    UITableViewCell.appearance.layoutMargins = UIEdgeInsetsZero;
    UITableViewCell.appearance.separatorInset = UIEdgeInsetsZero;
    UITableViewCell.appearance.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableViewCell.appearance.backgroundColor = UIColor.whiteColor;
    
    UICollectionView.appearance.scrollsToTop = false;
    UICollectionView.appearance.pagingEnabled = true;
    UICollectionView.appearance.bounces = false;
    
    UICollectionViewCell.appearance.layoutMargins = UIEdgeInsetsZero;
    UICollectionViewCell.appearance.backgroundColor = UIColor.whiteColor;
    
    UIImageView.appearance.userInteractionEnabled = true;
    UILabel.appearance.userInteractionEnabled = true;

    UIPageControl.appearance.pageIndicatorTintColor = barTintColor;
    UIPageControl.appearance.currentPageIndicatorTintColor = tintColor;
    UIPageControl.appearance.userInteractionEnabled = true;
    UIPageControl.appearance.hidesForSinglePage = true;
    
    
    UIProgressView.appearance.progressTintColor = barTintColor;
    UIProgressView.appearance.trackTintColor = UIColor.clearColor;


    UIDatePicker.appearance.datePickerMode = UIDatePickerModeDate;
    UIDatePicker.appearance.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];;
    UIDatePicker.appearance.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 13.4, *)) {
        UIDatePicker.appearance.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    
    
    UISlider.appearance.minimumTrackTintColor = tintColor;
    UISlider.appearance.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UISwitch.appearance.onTintColor = tintColor;
    UISwitch.appearance.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}

@end



@implementation UINavigationBarAppearance (Ext)

+ (instancetype)create:(UIColor *)tintColor
          barTintColor:(UIColor *)barTintColor
           shadowColor:(nullable UIColor *)shadowColor
                  font:(nullable UIFont *)font{

    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc]init];
    [barAppearance configureWithOpaqueBackground];
    barAppearance.backgroundColor = barTintColor;

    barAppearance.titleTextAttributes = @{
        NSForegroundColorAttributeName: tintColor,
    };
    
    UIBarButtonItemStateAppearance *itemNormal = barAppearance.buttonAppearance.normal;
    itemNormal.titleTextAttributes = @{NSForegroundColorAttributeName: tintColor,
//                                       NSBackgroundColorAttributeName: barTintColor,
                                       NSFontAttributeName: font ? : [UIFont systemFontOfSize:15]
    };

    UIBarButtonItemStateAppearance *itemDoneNomal = barAppearance.doneButtonAppearance.normal;
    itemDoneNomal.titleTextAttributes = @{NSForegroundColorAttributeName: tintColor,
//                                          NSBackgroundColorAttributeName: barTintColor,
                                          NSFontAttributeName: font ? : [UIFont systemFontOfSize:15]
    };
    
    
    if (shadowColor != nil) {
        barAppearance.shadowColor = shadowColor;
    }
    return barAppearance;
}

@end


@implementation UITabBarAppearance (Ext)

+ (instancetype)create:(UIColor *)tintColor barTintColor:(UIColor *)barTintColor font:(nullable UIFont *)font{
    UITabBarAppearance *barAppearance = [[UITabBarAppearance alloc]init];
    [barAppearance configureWithOpaqueBackground];
    barAppearance.backgroundColor = barTintColor;
    barAppearance.selectionIndicatorTintColor = tintColor;

    
    barAppearance.stackedLayoutAppearance = [UITabBarItemAppearance createWithNormal:@{
                                                NSForegroundColorAttributeName: tintColor,
                                                NSFontAttributeName: font ? : [UIFont systemFontOfSize:15]
                                            } selected:@{
                                                NSForegroundColorAttributeName: tintColor,
                                                NSFontAttributeName: font ? : [UIFont systemFontOfSize:15]
                                            }];
    return barAppearance;
}

@end


@implementation UITabBarItemAppearance (Ext)

+ (instancetype)createWithNormal:(NSDictionary<NSAttributedStringKey, id> *)normalAttrs selected:(NSDictionary<NSAttributedStringKey, id> *)selectedAttrs{

    UITabBarItemAppearance *itemAppearance = [[UITabBarItemAppearance alloc]init];
    itemAppearance.normal.titleTextAttributes = normalAttrs;
    itemAppearance.selected.titleTextAttributes = selectedAttrs;
    return itemAppearance;
}

@end
