//
//  GLGoogleImageSearchViewController.m
//  GoogleImageSearch
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import "GLGoogleImageSearchViewController.h"
#import "GLItemCell.h"
#import "GLGoogleImageSearch.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GLGoogleImageSearchViewController ()
@property (nonatomic, strong) GLGoogleImageSearch *googleImageSearchController;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GLGoogleImageSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSearchView];
    [self setupCollectionView];
    
    _googleImageSearchController = [GLGoogleImageSearch sharedInstance];
    _googleImageSearchController.page = 1;
    _googleImageSearchController.perPage = 10;
    _googleImageSearchController.shouldAutoAssignNextPage = YES;
    
    self.dataSource = [@[] mutableCopy];
}

//- (void) viewDidLayoutSubviews {
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//            self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
//        CGRect viewBounds = self.view.bounds;
//        CGFloat topBarOffset = self.topLayoutGuide.length;
//        viewBounds.origin.y = topBarOffset * -1;
//        self.view.bounds = viewBounds;
//        self.navigationController.navigationBar.translucent = NO;
//    }
//}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? self.dataSource.count : 0;;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSString *thumbnailURL = dict[@"thumbnailLink"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:thumbnailURL]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter && self.loadMoreButton) {
        UICollectionReusableView* container = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"loadMoreFooter" forIndexPath:indexPath];
        [container addSubview:self.loadMoreButton];
        return container;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate

// animates a cell expanding on selection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath: %@", indexPath);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        NSDictionary *dict = self.dataSource[indexPath.row];
        NSLog(@"dict: %@", dict);
        [self.delegate didSelectItem:dict];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.dataSource.count ? self.loadMoreButton.frame.size : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize rect = CGSizeMake(77, 77);
    return rect;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //[self.dataSource updateAutoCompleteResultsForTerm:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reset];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self reset];
    [self getSearchResultsForTerm:searchBar.text];
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        [self reset];
        [self getSearchResultsForTerm:searchBar.text];
    }
}


#pragma mark - Private

- (void)reset
{
    self.googleImageSearchController.page = 1;
    [self.dataSource removeAllObjects];
    [self.collectionView reloadData];
}

- (void)getSearchResultsForTerm:(NSString *)str
{
    if (str && str.length != 0) {
        [self.googleImageSearchController getImageForKeyword:str success:^(id responseObject) {
            //NSLog(@"success: %@", responseObject);
            
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray*)responseObject;
                [self.dataSource addObjectsFromArray:arr];
                [self.collectionView reloadData];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"failure: %@", error);
        }];
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)loadMoreAction:(id)sender
{
    [self getSearchResultsForTerm:self.searchBar.text];
}

- (UIButton *)loadMoreButton
{
    if (!_loadMoreButton) {
        _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadMoreButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 30);
        [_loadMoreButton setTitle:@"Tap to load more" forState:UIControlStateNormal];
        [_loadMoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loadMoreButton addTarget:self action:@selector(loadMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadMoreButton;
}

- (void)setupSearchView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    self.searchBar.placeholder = @"Search Items";
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
}

- (void)setupCollectionView
{
    // set up the collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.searchBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"loadMoreFooter"];
    [self.collectionView registerClass:[GLItemCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.collectionView];
}

@end
