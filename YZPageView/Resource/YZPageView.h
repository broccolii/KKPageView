//
//  YZPageView.h
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPageViewItem.h"

#import "YZPageViewDataSource.h"
#import "YZPageViewDelegate.h"
#import "YZPageTransitionAnimator.h"

@class YZPageViewItem, YZPageContainerViewLayout;
@interface YZPageView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

// TODO: 属性 支持 StoryBoard
@property (nonatomic, weak, nullable) IBInspectable id<YZPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBInspectable id<YZPageViewDelegate> delegate;
@property (nonatomic, weak, nullable) IBInspectable id<YZPageTransitionAnimator> animator;

@property (nonatomic, assign) IBInspectable NSInteger numberOfItems;

@property (nonatomic, strong, nullable) IBInspectable YZPageContainerViewLayout *containerViewLayout;
// default: NO
@property (nonatomic, assign, getter=isInfinite) IBInspectable BOOL infinite;

// default: NO
@property (nonatomic, assign, getter=isAutomaticSwitch) IBInspectable BOOL automaticSwitch;
// default: 3s
@property (nonatomic, assign) IBInspectable NSTimeInterval switchDurationTime;

// default: 0
@property (nonatomic, assign) IBInspectable CGFloat leadingSpacing;
// default: pageView size
@property (nonatomic, assign) IBInspectable CGSize itemSize;
// default: 0
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(nonnull NSString *)identifier;

- (nonnull YZPageViewItem *)dequeueReusableCellWithReuseIdentifier:(nonnull NSString *)identifier forIndexPath:(nonnull NSIndexPath *)indexPath;

@end
