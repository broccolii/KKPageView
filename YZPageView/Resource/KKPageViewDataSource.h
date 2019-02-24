//
//  KKPageViewDataSource.h
//  KKPageView
//
//  Created by Broccoli on 2017/2/17.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKPageView, KKPageViewItem;
@protocol KKPageViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPageView:(nonnull KKPageView *)pageView;

- (nonnull KKPageViewItem *)pageView:(nonnull KKPageView *)pageView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
