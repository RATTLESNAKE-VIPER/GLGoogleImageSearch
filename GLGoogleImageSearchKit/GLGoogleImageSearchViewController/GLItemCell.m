//
//  GLItemCell.m
//  GoogleImageSearch
//
//  Created by Gautam Lodhiya on 20/09/14.
//  Copyright (c) 2014 Gautam Lodhiya. All rights reserved.
//

#import "GLItemCell.h"

@implementation GLItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    [self addSubview:self.imageView];
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
}

@end
