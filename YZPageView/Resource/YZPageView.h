//
//  YZPageView.h
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZPageViewDataSource.h"
#import "YZPageViewDelegate.h"

@class YZPageViewItem, YZPageContainerViewLayout;
@interface YZPageView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
// TODO: 属性 支持 StoryBoard
@property (nonatomic, weak, nullable) id<YZPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<YZPageViewDelegate> delegate;

@property (nonatomic, strong, nullable) YZPageContainerViewLayout *containerViewLayout;
// default: NO
@property (nonatomic, assign, getter=isInfinite) BOOL infinite;

// default: NO
@property (nonatomic, assign, getter=isAutomaticSwitch) BOOL automaticSwitch;
// default: 3s
@property (nonatomic, assign) NSTimeInterval switchDurationTime;

// default: 0
@property (nonatomic, assign) CGFloat leadingSpacing;
// default: pageView size
@property (nonatomic, assign) CGSize itemSize;
// default: 0
@property (nonatomic, assign) CGFloat itemSpacing;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(nonnull NSString *)identifier;

- (nonnull YZPageViewItem *)dequeueReusableCellWithReuseIdentifier:(nonnull NSString *)identifier forIndexPath:(nonnull NSIndexPath *)indexPath;

@end
