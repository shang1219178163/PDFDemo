//
//  JFPdfViewController.m
//  PDFDemo
//
//  Created by shangbinbin on 2021/12/9.
//  Copyright © 2021 Japho. All rights reserved.
//

#import "JFPdfViewController.h"
#import <PDFKit/PDFKit.h>
#import "UIAlertController+Helper.h"
#import "PDFDocument+Helper.h"
#import "NSArray+Helper.h"

#import "JFThumbnailViewController.h"
#import "JFOutlineViewController.h"
#import "JFSearchViewController.h"

@interface JFPdfViewController () <JFThumbnailViewControllerDelegate,JFOutlineViewControllerDelegate,JFSearchViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSArray<NSString *> *fileNames;

@property (nonatomic, strong) NSString *fileName;

//@property (nonatomic, strong) NSArray<NSURL *> *fileURLs;
//@property (nonatomic, strong) NSURL *fileURL;

@property (nonatomic, strong) PDFView *pdfView;
@property (nonatomic, strong) PDFDocument *document;
@property (nonatomic, strong) UIView *zoomBaseView;
@property (nonatomic, strong) UIButton *btnZoomIn;
@property (nonatomic, strong) UIButton *btnZoomOut;
@property (nonatomic, assign) BOOL hasDisplay;


@end

@implementation JFPdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"PDF";
    
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(selectedAction)];
    
//    self.navigationItem.leftBarButtonItem = changeItem;
//    self.navigationItem.rightBarButtonItem = menuItem;
    self.navigationItem.rightBarButtonItems = @[menuItem, selectItem];
    [self setupPDFView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.pdfView.frame = self.view.bounds;
    self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit;
}

- (void)setupPDFView {
    self.document = [PDFDocument docForResource:self.fileNames.firstObject ofType:nil];
    if (!self.document) {
        [UIAlertController alertControllerWithTitle:@"file error" message:nil preferredStyle:UIAlertControllerStyleAlert].present(true, nil);
        return;
    }

    [self.view addSubview:self.pdfView];
    [self.view addSubview:self.zoomBaseView];
    
    self.hasDisplay = YES;
}


#pragma mark - --- JFThumbnailViewController Delegate ---

- (void)thumbnailViewController:(JFThumbnailViewController *)controller didSelectAtIndex:(NSIndexPath *)indexPath {
    PDFPage *page = [self.document pageAtIndex:indexPath.item];
    [self.pdfView goToPage:page];
}

#pragma mark - --- JFOutlineViewController Delegate ---

- (void)outlineViewController:(JFOutlineViewController *)controller didSelectOutline:(PDFOutline *)outline {
    NSLog(@"%s",__func__);
    PDFAction *action = outline.action;
    PDFActionGoTo *goToAction = (PDFActionGoTo *)action;
    
    if (goToAction) {
        [self.pdfView goToDestination:goToAction.destination];
    }
}

#pragma mark - --- JFSearchViewController Delegate ---

- (void)searchViewController:(JFSearchViewController *)controller didSelectSearchResult:(PDFSelection *)selection {
    selection.color = [UIColor yellowColor];
    self.pdfView.currentSelection = selection;
    [self.pdfView goToSelection:selection];
}

#pragma mark - --- document Delegate ---


#pragma mark - --- Customed Action ---

- (void)thumbnailAction {
    NSLog(@"%s",__func__);
    
    JFThumbnailViewController *thumbnailViewController = [[JFThumbnailViewController alloc] init];
    thumbnailViewController.pdfDocument = self.document;
    thumbnailViewController.delegate = self;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:thumbnailViewController] animated:YES completion:nil];
}


- (void)shareAction {
    UIDocumentInteractionController *docController = [[UIDocumentInteractionController alloc] init];
//    docController.delegate = self;
    
    NSString *path = [NSBundle.mainBundle pathForResource:self.fileName ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    docController.URL = fileUrl;

//    _docController.UTI = self.url.getUTI;
    [docController presentPreviewAnimated:YES];
    BOOL isSuccess = [docController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
    if (isSuccess == NO) {
        NSLog(@"%@",@"没有程序可以打开要分享的文件");
    }
}


- (void)outlineAction {
    NSLog(@"%s",__func__);
    
    PDFOutline *outline = self.document.outlineRoot;
    
    if (outline) {
        JFOutlineViewController *outlineViewController = [[JFOutlineViewController alloc] init];
        outlineViewController.outlineRoot = outline;
        outlineViewController.delegate = self;
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:outlineViewController] animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                                 message:@"This pdf do not have outline!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)searchAction {
    NSLog(@"%s",__func__);
    
    JFSearchViewController *searchViewController = [[JFSearchViewController alloc] init];
    searchViewController.pdfDocment = self.document;
    searchViewController.delegate = self;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:searchViewController] animated:YES completion:nil];
}

- (void)selectedAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Select" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addActionTitles:self.fileNames handler:^(UIAlertController * _Nonnull vc, UIAlertAction * _Nonnull action) {
        self.document = [PDFDocument docForResource:action.title ofType:nil];

    }];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)menuAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Menu"
                                                                             message:@"Select an action."
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self searchAction];
    }];
    UIAlertAction *outlineAction = [UIAlertAction actionWithTitle:@"Outline" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self outlineAction];
    }];
    UIAlertAction *thumbAction = [UIAlertAction actionWithTitle:@"Thumbnail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self thumbnailAction];
    }];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareAction];
    }];
    
    [alertVC addAction:searchAction];
    [alertVC addAction:outlineAction];
    [alertVC addAction:thumbAction];
    [alertVC addAction:shareAction];
    [alertVC addAction:action];

    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)singleTapAction {
    NSLog(@"%s",__func__);
    self.zoomBaseView.hidden = NO;

    if (self.hasDisplay) {
        self.zoomBaseView.alpha = 1.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.zoomBaseView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.zoomBaseView.hidden = YES;
        }];
    } else {
        self.zoomBaseView.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.zoomBaseView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.zoomBaseView.hidden = NO;
        }];
    }
    
    self.hasDisplay = !self.hasDisplay;
}

- (void)doubleTapAction {
    NSLog(@"%f_%f", self.pdfView.scaleFactor, self.pdfView.scaleFactorForSizeToFit);
    [UIView animateWithDuration:0.15 animations:^{
        self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit * (self.pdfView.scaleFactor == self.pdfView.scaleFactorForSizeToFit ? 2 : 1);
    }];
}

- (void)zoomInAction {
    [UIView animateWithDuration:0.1 animations:^{
        [self.pdfView zoomIn:nil];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)zoomOutAction {
    [UIView animateWithDuration:0.1 animations:^{
        [self.pdfView zoomOut:nil];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - --- setter & getter ---
- (NSArray<NSString *> *)fileNames{
    if (!_fileNames) {
        NSArray<NSURL *> *urls = [NSBundle.mainBundle URLsForResourcesWithExtension:@"pdf" subdirectory:nil];

        NSArray<NSString *> *list = [urls map:^id _Nonnull(NSURL * _Nonnull obj, NSUInteger idx) {
            return obj.lastPathComponent;
        }];
        NSLog(@"list: %@", list);
        _fileNames = list;
    }
    return _fileNames;
}

- (UIView *)zoomBaseView {
    if (!_zoomBaseView) {
        UIColor *blueColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0];
        
        _zoomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 100)];
        _zoomBaseView.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 40,
                                           [UIScreen mainScreen].bounds.size.height - [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom - 160);
        _zoomBaseView.backgroundColor = [UIColor whiteColor];
        
        _btnZoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnZoomIn.frame = CGRectMake(0, 0, 40, 50);
        _btnZoomIn.layer.borderWidth = 1;
        _btnZoomIn.layer.borderColor = blueColor.CGColor;
        [_btnZoomIn setTitle:@"+" forState:UIControlStateNormal];
        [_btnZoomIn setTitleColor:blueColor forState:UIControlStateNormal];
        [_btnZoomIn.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnZoomIn addTarget:self action:@selector(zoomInAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomBaseView addSubview:_btnZoomIn];
        
        _btnZoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnZoomOut.frame = CGRectMake(0, 50, 40, 50);
        _btnZoomOut.layer.borderWidth = 1;
        _btnZoomOut.layer.borderColor = blueColor.CGColor;
        [_btnZoomOut setTitle:@"-" forState:UIControlStateNormal];
        [_btnZoomOut setTitleColor:blueColor forState:UIControlStateNormal];
        [_btnZoomOut.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnZoomOut addTarget:self action:@selector(zoomOutAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomBaseView addSubview:_btnZoomOut];
    }
    
    return _zoomBaseView;
}


- (PDFView *)pdfView{
    if (!_pdfView) {
        _pdfView = [[PDFView alloc] initWithFrame:self.view.bounds];
        _pdfView.autoScales = YES;
        _pdfView.userInteractionEnabled = YES;
        _pdfView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
        [_pdfView addGestureRecognizer:singleTapGesture];
        [_pdfView addGestureRecognizer:doubleTapGesture];
    }
    return _pdfView;
}

- (void)setDocument:(PDFDocument *)document{
    _document = document;
    self.pdfView.document = document;
    self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit;
    
    self.title = document.documentURL.lastPathComponent;
    self.fileName = document.documentURL.lastPathComponent;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}


@end
