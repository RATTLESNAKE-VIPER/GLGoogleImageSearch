//
//  GLGoogleImageSearch.h
//  GoogleImageSearch
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kGoogleAPIKey;

typedef void(^SearchDidStartBlock)(void);
typedef void(^SearchDoneBlock)(id responseObject);
typedef void(^SearchFailBlock)(NSError* error);


@interface GLGoogleImageSearch : NSObject
@property (nonatomic, assign) BOOL shouldAutoAssignNextPage;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger perPage;
@property (nonatomic, assign) NSInteger filter;

+ (instancetype)sharedInstance;
- (void)getImageForKeyword:(NSString*)keyword success:(SearchDoneBlock)doneBlock failure:(SearchFailBlock)failBlock;

@end
