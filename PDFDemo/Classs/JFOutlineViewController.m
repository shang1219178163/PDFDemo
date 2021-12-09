//
//  JFOutlineViewController.m
//  PDFDemo
//
//  Created by Japho on 2018/11/13.
//  Copyright © 2018 Japho. All rights reserved.
//

#import "JFOutlineViewController.h"
#import "JFOutlineCell.h"

NSString * const outlineViewControllerCellID = @"outlineViewControllerCellID";

@interface JFOutlineViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *marr;

@end

@implementation JFOutlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Outline";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancle" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    
    [self.view addSubview:self.tableView];
}

- (void)cancleAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - --- Customed Methods ---

- (void)insertOulineWithParentOutline:(PDFOutline *)parentOutline {
    NSInteger baseIndex = [self.marr indexOfObject:parentOutline];
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++) {
        PDFOutline *tempOuline = [parentOutline childAtIndex:i];
        tempOuline.isOpen = NO;
        [self.marr insertObject:tempOuline atIndex:baseIndex + i + 1];
    }
}

- (void)removeOutlineWithParentOuline:(PDFOutline *)parentOutline {
    if (parentOutline.numberOfChildren <= 0) return;
    
    for (int i = 0; i < parentOutline.numberOfChildren; i++) {
        PDFOutline *node = [parentOutline childAtIndex:i];
        
        if (node.numberOfChildren > 0 && node.isOpen) {
            [self removeOutlineWithParentOuline:node];
            
            NSInteger index = [self.marr indexOfObject:node];
            if (index) {
                [self.marr removeObjectAtIndex:index];
            }
        } else {
            if ([self.marr containsObject:node]) {
                NSInteger index = [self.marr indexOfObject:node];
                if (index) {
                    [self.marr removeObjectAtIndex:index];
                }
            }
        }
    }
}

- (NSInteger)findDepthWithOutline:(PDFOutline *)outline {
    NSInteger depth = -1;
    PDFOutline *tempOutline = outline;
    
    while (tempOutline.parent != nil) {
        depth++;
        tempOutline = tempOutline.parent;
    }
    
    return depth;
}

#pragma mark - --- UITableView DataSource ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFOutlineCell *cell = [tableView dequeueReusableCellWithIdentifier:outlineViewControllerCellID forIndexPath:indexPath];
    
    PDFOutline *outline = self.marr[indexPath.row];
    
    cell.lblTitle.text = outline.label;
    cell.lblPage.text = outline.destination.page.label;
    cell.btnArrow.selected = outline.isOpen;
    cell.btnArrow.enabled = outline.numberOfChildren > 0;

    if (outline.numberOfChildren > 0) {
        UIImage *image = outline.isOpen ? [UIImage imageNamed:@"arrow_down"] : [UIImage imageNamed:@"arrow_right"];
        [cell.btnArrow setImage:image forState:UIControlStateNormal];
    } else {
        [cell.btnArrow setImage:nil forState:UIControlStateNormal];
    }
    
    cell.outlineBlock = ^(UIButton * _Nonnull button) {
        if (outline.numberOfChildren <= 0) return;
        outline.isOpen = button.isSelected;

        if (button.isSelected){
            [self insertOulineWithParentOutline:outline];
        } else {
            [self removeOutlineWithParentOuline:outline];
        }

        [tableView reloadData];
        
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDFOutline *outline = self.marr[indexPath.row];
    NSInteger depth = [self findDepthWithOutline:outline];
    
    return depth;
}

#pragma mark - --- UITableView Delegate ---

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    
    PDFOutline *outline = [self.marr objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(outlineViewController:didSelectOutline:)]) {
        [self.delegate outlineViewController:self didSelectOutline:outline];
    }
    
    [self cancleAction];
}

#pragma mark - --- Setter & Getter ---

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JFOutlineCell" bundle:nil] forCellReuseIdentifier:outlineViewControllerCellID];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSMutableArray *)marr {
    if (!_marr) {
        _marr = [[NSMutableArray alloc] init];
    }
    return _marr;
}

- (void)setOutlineRoot:(PDFOutline *)outlineRoot {
    _outlineRoot = outlineRoot;
    
    for (int i = 0; i < outlineRoot.numberOfChildren; i++) {
        PDFOutline *outline = [outlineRoot childAtIndex:i];
        outline.isOpen = NO;
        [self.marr addObject:outline];
    }
    
    [self.tableView reloadData];
}

@end
