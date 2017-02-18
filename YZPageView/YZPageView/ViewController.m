//
//  ViewController.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "ViewController.h"
#import "YZPageView.h"

@interface ViewController ()<YZPageViewDelegate, YZPageViewDataSource, YZPageTransitionAnimator>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageView];
}


- (void)setupPageView {
    
    YZPageView *pageView = [[YZPageView alloc] init];
    pageView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    
    [pageView registerClass:[YZPageViewItem class] forCellWithReuseIdentifier:@"YZPageViewItem"];
    pageView.delegate = self;
    pageView.dataSource = self;
//    pageView.animator = self;
    
    pageView.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 100);
    pageView.leadingSpacing = 20;
    pageView.itemSpacing = 30;
    
    [self.view addSubview:pageView];
}

#pragma mark - YZPageViewDataSource
- (NSInteger)numberOfItemsInPageView:(YZPageView *)pageView {
    return 10;
}

- (YZPageViewItem *)pageView:(YZPageView *)pageView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZPageViewItem *cell = [pageView dequeueReusableCellWithReuseIdentifier:@"YZPageViewItem" forIndexPath:indexPath];
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    return cell;
}

#pragma mark - YZPageTransitionAnimator
- (void)transitionAnimationWithOffsetPercent:(CGFloat)offSetPersent
                            layoutAttributes:(YZPageContainerViewLayoutAttributes *)layoutAttributes {
    if (fabs(offSetPersent) >= 1) {
        layoutAttributes.contentView.transform = CGAffineTransformIdentity;
        layoutAttributes.alpha = 1.0;
    } else {
        CGFloat rotateFactor = M_PI_4 * offSetPersent;
        layoutAttributes.zIndex = layoutAttributes.indexPath.row;
        layoutAttributes.alpha = 1.0 - fabs(offSetPersent);
        layoutAttributes.contentView.transform = CGAffineTransformRotate(layoutAttributes.contentView.transform, rotateFactor);
    }
}

@end
