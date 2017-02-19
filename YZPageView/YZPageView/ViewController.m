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

@property (strong, nonatomic) IBOutlet YZPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageView];
}


- (void)setupPageView {
//    
//    YZPageView *pageView = [[YZPageView alloc] init];
//    pageView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
//    

//    pageView.delegate = self;
//    pageView.dataSource = self;
//    pageView.animator = self;
//    pageView.infinite = YES;
//    pageView.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 100);
//    pageView.leadingSpacing = 20;
//    pageView.itemSpacing = 30;
//    
//    [self.view addSubview:pageView];
//    
//    self.pageView = pageView;
    
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    [self.pageView registerClass:[YZPageViewItem class] forCellWithReuseIdentifier:@"YZPageViewItem"];
}

#pragma mark - YZPageViewDataSource
- (NSInteger)numberOfItemsInPageView:(YZPageView *)pageView {
    return 5;
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
    [self.pageView.containerViewLayout invalidateLayout];
    CGFloat scale = MAX(1 - (1-0.65) * fabs(offSetPersent), 0.65);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CGFloat alpha = (0.6 + (1-fabs(offSetPersent))*(1-0.6));
    CGFloat zIndex = (1-fabs(offSetPersent)) * 10;
    layoutAttributes.alpha = alpha;
    layoutAttributes.transform = transform;
    layoutAttributes.zIndex = (int)zIndex;
}

@end
