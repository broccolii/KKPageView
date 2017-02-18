//
//  ViewController.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "ViewController.h"
#import "YZPageView.h"
#import "YZPageViewCell.h"

@interface ViewController ()<YZPageViewDelegate, YZPageViewDataSource>

@property (nonatomic, strong) YZPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageView];
}


- (void)setupPageView {
    YZPageView *pageView = [[YZPageView alloc] init];
    pageView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    pageView.backgroundColor = [UIColor grayColor];
    
    pageView.delegate = self;
    pageView.dataSource = self;
    
    [self.view addSubview:pageView];
    
    [self.pageView registerClass:[YZPageViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - YZPageViewDataSource
- (NSInteger)numberOfItemsInPageView:(YZPageView *)pageView {
    return 5;
}

- (YZPageViewCell *)pageView:(YZPageView *)pageView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZPageViewCell *cell = [pageView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:indexPath.row / 10];
    return cell;
}


@end
