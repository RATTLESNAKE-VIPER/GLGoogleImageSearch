//
//  GoogleImageSearchTests.m
//  GoogleImageSearchTests
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AGAsyncTestHelper.h"
#import "GLGoogleImageSearch.h"

static NSInteger kRequestTimeOutInSeconds = 10;

@interface GoogleImageSearchTests : XCTestCase
@property (nonatomic, strong) GLGoogleImageSearch *googleImageSearchController;
@end

@implementation GoogleImageSearchTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _googleImageSearchController = [GLGoogleImageSearch sharedInstance];
    //_googleImageSearchController.page = 1;
    _googleImageSearchController.perPage = 1;
    _googleImageSearchController.shouldAutoAssignNextPage = YES;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetImageForInitialPage
{
    __block BOOL jobDone = NO;
    
    [self.googleImageSearchController getImageForKeyword:@"iphone" success:^(id responseObject) {
        XCTAssertNotNil(responseObject);
        NSLog(@"success: %@", responseObject);
        
        XCTAssertTrue([responseObject isKindOfClass:[NSArray class]], @"responseObject is not NSArray type");
        
        jobDone = YES;
        
    } failure:^(NSError *error) {
        XCTFail(@"failure: %@", error);
        jobDone = YES;
    }];
    
    AGWW_WAIT_WHILE(!jobDone, kRequestTimeOutInSeconds);
}

- (void)testGetImageForNextPage
{
    __block BOOL jobDone = NO;
    
    [self.googleImageSearchController getImageForKeyword:@"iphone" success:^(id responseObject) {
        XCTAssertNotNil(responseObject);
        NSLog(@"success: %@", responseObject);
        
        XCTAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"responseObject is not NSDictionary type");
        
        jobDone = YES;
        
    } failure:^(NSError *error) {
        XCTFail(@"failure: %@", error);
        jobDone = YES;
    }];
    
    AGWW_WAIT_WHILE(!jobDone, kRequestTimeOutInSeconds);
}

@end
