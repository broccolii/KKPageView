//
//  YZPageView.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "YZPageView.h"
#import "YZPageContainerView.h"
#import "YZPageViewItem.h"
#import "YZPageContainerViewLayout.h"

@interface YZPageView () 

@property (nonatomic, strong) YZPageContainerView *containerView;

@end

@implementation YZPageView

#pragma mark - Initialize
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setupContainerView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    [self setupContainerView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
//    [self setupContainerView];
    return self;
}

#pragma mark - Life Circle
- (void)dealloc {
    self.containerView.dataSource = nil;
    self.containerView.delegate = nil;
}

#pragma mark - Public Method
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(nonnull NSString *)identifier {
    [self.containerView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (nonnull YZPageViewItem *)dequeueReusableCellWithReuseIdentifier:(nonnull NSString *)identifier forIndexPath:(NSIndexPath *)index {
    // TODO: 复用的时候这里的section 会不会有问题
    YZPageViewItem *pageViewItem = [self.containerView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:index];
    return pageViewItem;
}

#pragma mark - Override 
-(void)layoutSubviews {
    self.containerView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource pageView:self cellForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Private method
- (NSInteger)numberOfSections {
    if (self.infinite) {
        return INT64_MAX / [self numberOfItems];
    }
    
    return 1;
}

- (NSInteger)numberOfItems {
    return [self.dataSource numberOfItemsInPageView:self];
}

#pragma mark - setup UI
- (void)setupContainerView {
    [self addSubview:self.containerView];
}

#pragma mark - Getter
- (YZPageContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[YZPageContainerView alloc] initWithFrame:CGRectZero collectionViewLayout:self.containerViewLayout];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (YZPageContainerViewLayout *)containerViewLayout {
    if (!_containerViewLayout) {
        _containerViewLayout = [[YZPageContainerViewLayout alloc] init];
    }
    return _containerViewLayout;
}

- (CGSize)itemSize {
    if (CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        _itemSize = self.frame.size;
    }
    return _itemSize;
}

@end
