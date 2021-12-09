//
//  JFSearchViewController.m
//  PDFDemo
//
//  Created by Japho on 2018/11/14.
//  Copyright © 2018 Japho. All rights reserved.
//

#import "JFSearchViewController.h"
#import "JFSeachCell.h"

NSString * const searchViewControllerTableViewCellID = @"searchViewControllerTableViewCellID";

@interface JFSearchViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,PDFDocumentDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *marr;

@end

@implementation JFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)cancleAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - --- UITableView DataSource ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDFSelection *selection = self.marr[indexPath.row];
    PDFPage *page = selection.pages[0];
    PDFOutline *outline = [self.pdfDocment outlineItemForSelection:selection];
    
    NSString *destinationStr = [NSString stringWithFormat:@"%@  PAGE: %@", outline.label, page.label];
    
    PDFSelection *extendSelection = [selection copy];
    [extendSelection extendSelectionAtStart:10];
    [extendSelection extendSelectionAtEnd:90];
    [extendSelection extendSelectionForLineBoundaries];
    
    NSRange range = [extendSelection.string rangeOfString:selection.string options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:extendSelection.string];
    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    
    JFSeachCell *cell = [tableView dequeueReusableCellWithIdentifier:searchViewControllerTableViewCellID forIndexPath:indexPath];
    
    cell.lblDestination.text = destinationStr;
    
    cell.lblResult.attributedText = attrStr;
    
    return cell;
}

#pragma mark - --- UITableView Delegate ---

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    
    PDFSelection *selection = self.marr[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchResult:)]) {
        [self.delegate searchViewController:self didSelectSearchResult:selection];
    }
    
    [self cancleAction];
}

#pragma mark - --- UIScrollView Delegate ---

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - --- UISearchBar Delegate ---

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.pdfDocment cancelFindString];
    [self cancleAction];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length < 2) {
        return;
    }
    
    [self.marr removeAllObjects];
    [self.tableView reloadData];
    
    [self.pdfDocment cancelFindString];
    self.pdfDocment.delegate = self;
    [self.pdfDocment beginFindString:searchText withOptions:NSCaseInsensitiveSearch];
}

#pragma mark - --- PDFDocument Delegate ---

- (void)didMatchString:(PDFSelection *)instance {
    [self.marr addObject:instance];
    [self.tableView reloadData];
}

#pragma mark - --- setter & getter ---

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JFSeachCell" bundle:nil] forCellReuseIdentifier:searchViewControllerTableViewCellID];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 150;
    }
    
    return _tableView;
}

- (NSMutableArray *)marr {
    if (!_marr) {
        _marr = [[NSMutableArray alloc] init];
    }
    
    return _marr;
}

@end
