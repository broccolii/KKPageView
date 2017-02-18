//
//  ViewController.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "ViewController.h"
#import "YZPageView.h"
#import "YZPageViewItem.h"
#import "YZPageContainerView.h"
#import "YZPageContainerViewLayout.h"

@interface ViewController ()<YZPageViewDelegate, YZPageViewDataSource>


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
    
    pageView.itemSize = CGSizeMake(100, 100);
    pageView.leadingSpacing = 20;
    pageView.itemSpacing = 30;
    
    [self.view addSubview:pageView];
    
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


@end
