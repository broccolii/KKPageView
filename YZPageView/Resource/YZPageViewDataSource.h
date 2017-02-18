//
//  YZPageViewDataSource.h
//  YZPageView
//
//  Created by Broccoli on 2017/2/17.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZPageView, YZPageViewCell;
@protocol YZPageViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPageView:(YZPageView *)pageView;

- (YZPageViewCell *)pageView:(YZPageView *)pageView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
