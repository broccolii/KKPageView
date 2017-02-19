//
//  YZPageViewDataSource.h
//  YZPageView
//
//  Created by Broccoli on 2017/2/17.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZPageView, YZPageViewItem;
@protocol YZPageViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPageView:(nonnull YZPageView *)pageView;

- (nonnull YZPageViewItem *)pageView:(nonnull YZPageView *)pageView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
