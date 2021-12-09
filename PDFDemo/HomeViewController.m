//
//  HomeViewController.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "HomeViewController.h"
#import "JFPdfViewController.h"
#import "UINavigationBar+Helper.h"

@interface HomeViewController ()

@property(nonatomic, strong) UIButton *button;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;

    self.title = @"PDFDemo";
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"blue" style:UIBarButtonItemStylePlain target:self action:@selector(themAction:)];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"white" style:UIBarButtonItemStylePlain target:self action:@selector(themAction:)];
    self.navigationItem.rightBarButtonItems = @[menuItem, selectItem];
    
    [self.view addSubview:self.button];
    
    self.button.center = self.view.center;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)themAction: (UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"white"]) {
        [self.navigationController.navigationBar setColor:UIColor.blackColor barTintColor:UIColor.whiteColor shadowColor:nil];
    } else {
        [self.navigationController.navigationBar setColor:UIColor.whiteColor barTintColor:UIColor.systemBlueColor shadowColor:nil];
    }
}

- (void)openPDFReader {
    JFPdfViewController *vc = [[JFPdfViewController alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -lazy
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(0, 0, 200, 50);
        [_button setTitle:@"Open PDF Reader." forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(openPDFReader) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}


@end
