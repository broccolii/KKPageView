//
//  KKPageView.h
//  KKPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageViewItem.h"

#import "KKPageViewDataSource.h"
#import "KKPageViewDelegate.h"
#import "KKPageTransitionAnimator.h"

@class KKPageViewItem, KKPageContainerViewLayout;
@interface KKPageView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, weak, nullable) IBOutlet id<KKPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBOutlet id<KKPageViewDelegate> delegate;
@property (nonatomic, weak, nullable) IBOutlet id<KKPageTransitionAnimator> animator;
#else
@property (nonatomic, weak, nullable) IBInspectable id<KKPageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBInspectable id<KKPageViewDelegate> delegate;
@property (nonatomic, weak, nullable) IBInspectable id<KKPageTransitionAnimator> animator;
#endif

@property (nonatomic, assign) IBInspectable NSInteger numberOfItems;

@property (nonatomic, strong, nullable) IBInspectable KKPageContainerViewLayout *containerViewLayout;
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

@property (nonatomic, strong, nonnull) UIView *backgroundView;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(nonnull NSString *)identifier;

- (nonnull KKPageViewItem *)dequeueReusableCellWithReuseIdentifier:(nonnull NSString *)identifier forIndexPath:(nonnull NSIndexPath *)indexPath;

@end
