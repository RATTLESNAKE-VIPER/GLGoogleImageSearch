//
//  GLGoogleImageSearchViewController.h
//  GoogleImageSearch
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLImageSearchDelegate <NSObject>
@optional;
- (void)didSelectItem:(NSDictionary *)dict;
@end

@interface GLGoogleImageSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *loadMoreButton;
@property (weak,   nonatomic) id<GLImageSearchDelegate> delegate;
@end
