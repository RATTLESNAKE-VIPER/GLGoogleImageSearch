//
//  GLGoogleImageSearch.m
//  GoogleImageSearch
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import "GLGoogleImageSearch.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBaseURLString = @"https://www.googleapis.com";
NSString * const kGoogleAPIKey = @"AIzaSyA9jHdH8BqMR5GaP4TsHHlxo7BcIN2a6Ac";//@"AIzaSyB48slM2dokJ56U588DttNqpJfoyDhCkGk";

@interface GLGoogleImageSearch()

@end

@implementation GLGoogleImageSearch

- (instancetype)init
{
    if ((self = [super init])) {
        _shouldAutoAssignNextPage = YES;
        _page = 1;
        _perPage = 10;
    }
    
    return self;
}

- (void)dealloc
{
    
}

// MARK: - Public Helpers

+ (instancetype)sharedInstance;
{
    static GLGoogleImageSearch *obj;
    static dispatch_once_t singletonToken;
    dispatch_once(&singletonToken, ^{
        obj = [[GLGoogleImageSearch alloc] init];
    });
    return obj;
}

- (void)getImageForKeyword:(NSString*)keyword success:(SearchDoneBlock)doneBlock failure:(SearchFailBlock)failBlock;
{
    NSDictionary *params = [self queryParamsForSearchTerms:keyword];
    return [self getImageForKeyword:keyword withQueryParams:params success:doneBlock failure:failBlock];
}


- (void)getImageForKeyword:(NSString*)keyword withQueryParams:(NSDictionary *)params success:(SearchDoneBlock)doneBlock failure:(SearchFailBlock)failBlock;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self URLString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *outArr = [@[] mutableCopy];
        if (self.shouldAutoAssignNextPage) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *rootDict = (NSDictionary *)responseObject;
                
                if (rootDict[@"items"]) {
                    NSArray *items = rootDict[@"items"];
                    
                    for (NSDictionary *itemDict in items) {
                        NSString *link = itemDict[@"link"];
                        
                        NSDictionary *imageDict = itemDict[@"image"];
                        NSString *thumbnailLink = imageDict[@"thumbnailLink"];
                        NSString *contextLink = imageDict[@"contextLink"];
                        
                        NSDictionary *outDict = @{@"link" : link,
                                                @"thumbnailLink" : thumbnailLink,
                                                @"contextLink" : contextLink};
                        [outArr addObject:outDict];
                    }
                }
                
                if (rootDict[@"queries"]) {
                    if (rootDict[@"queries"][@"nextPage"]) {
                        NSDictionary *nextPageQueries = rootDict[@"queries"][@"nextPage"][0];
                        self.page = [nextPageQueries[@"startIndex"] integerValue];
                    }
                }
            }
        }
        doneBlock(outArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlock(error);
    }];
}


// MARK: - Private Helpers

- (NSDictionary *)queryParamsForSearchTerms:(NSString *)searchTerms;
{
    return @{@"searchType" : @"image",
             @"safe" : @"high",
             @"key" : kGoogleAPIKey,
             @"cx" : @"011187086756202966114:svrjsuftcw4",
             @"q" : searchTerms,
             @"num" : @(self.perPage),
             @"start" : @(self.page),
             @"rights" : @"(cc_publicdomain%7Ccc_attribute%7Ccc_sharealike%7Ccc_nonderived).-(cc_noncommercial)"};
}

- (NSString *)URLString;
{
    return [NSString stringWithFormat:@"%@/customsearch/v1", kBaseURLString];
}

- (NSString *)dummyURLString;
{
    return @"https://www.googleapis.com/customsearch/v1?searchType=image&safe=high&key=AIzaSyB48slM2dokJ56U588DttNqpJfoyDhCkGk&cx=011187086756202966114%3Asvrjsuftcw4&q=iphone&num=10&start=1&rights=(cc_publicdomain%7Ccc_attribute%7Ccc_sharealike%7Ccc_nonderived).-(cc_noncommercial)";
}

@end
