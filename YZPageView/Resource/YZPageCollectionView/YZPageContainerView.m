//
//  YZPageCollectionView.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "YZPageContainerView.h"

@implementation YZPageContainerView

#pragma mark - Initialize
- (instancetype)init {
    if (!self) {
        return nil;
    }
    [self setupUIComponent];
    return self;
}

#pragma mark - setup
- (void)setupUIComponent {
    self.contentInset = UIEdgeInsetsZero;
    self.scrollsToTop = NO;
    self.pagingEnabled = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

@end
