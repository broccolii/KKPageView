//
//  KKPageView.m
//  KKPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "KKPageView.h"
#import "KKPageContainerView.h"
#import "KKPageViewItem.h"
#import "KKPageContainerViewLayout.h"

@interface KKPageView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) KKPageContainerView *containerView;

@property (nonatomic, strong) NSTimer *automaticSwitchTimer;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation KKPageView

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    [self setupContainerView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    [self setupContainerView];
    return self;
}

- (void)commonInit {
    self.switchDurationTime = 3.0;
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

- (nonnull KKPageViewItem *)dequeueReusableCellWithReuseIdentifier:(nonnull NSString *)identifier forIndexPath:(NSIndexPath *)index {
    // TODO: 复用的时候这里的section 会不会有问题
    KKPageViewItem *pageViewItem = [self.containerView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:index];
    return pageViewItem;
}

- (void)reloadData {
    [self.containerView reloadData];
}

#pragma mark - Override
- (void)layoutSubviews {
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.containerView.frame = self.contentView.bounds;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.automaticSwitch) {
        [self startTimer];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource pageView:self cellForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.automaticSwitch) {
        [self stopTimer];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.automaticSwitch) {
        [self startTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.numberOfItems > 0) {
        NSInteger currentIndex = lround(scrollView.contentOffset.x / (self.itemSize.width + self.itemSpacing)) % self.numberOfItems;
        NSInteger currentSection = lround(scrollView.contentOffset.x / (self.itemSize.width + self.itemSpacing)) / self.numberOfItems;
        if (self.currentIndexPath.item != currentIndex || self.currentIndexPath.section != currentSection) {
            self.currentIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:currentSection];
        }
    }
}

#pragma mark - Private method
- (NSInteger)numberOfSections {
    self.numberOfItems = [self.dataSource numberOfItemsInPageView:self];
    if (self.infinite) {
        return UINT16_MAX / self.numberOfItems;
    }
    
    return 1;
}

#pragma mark - setup UI
- (void)setupContainerView {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.containerView];
}

#pragma mark - Automatic Switch
- (void)startTimer {
    self.automaticSwitchTimer = [NSTimer scheduledTimerWithTimeInterval:self.switchDurationTime target:self selector:@selector(switchNextPage) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.automaticSwitchTimer invalidate];
    self.automaticSwitchTimer = nil;
}

- (void)switchNextPage {
    if (self.containerView.isTracking) {
        return;
    }
    
    NSIndexPath *nextIndexPath;
    
    if (self.currentIndexPath.item + 1 < self.numberOfItems) {
        nextIndexPath = [NSIndexPath indexPathForItem:self.currentIndexPath.item + 1 inSection:self.currentIndexPath.section];
    } else {
        if (self.infinite) {
            nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.currentIndexPath.section + 1];
        } else {
            nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        }
    }
    CGPoint contentOffset = [self.containerViewLayout contentOffsetForIndexPath:nextIndexPath];
    [self.containerView setContentOffset:contentOffset animated:YES];
}

#pragma mark - Getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (KKPageContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[KKPageContainerView alloc] initWithFrame:CGRectZero collectionViewLayout:self.containerViewLayout];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (KKPageContainerViewLayout *)containerViewLayout {
    if (!_containerViewLayout) {
        _containerViewLayout = [[KKPageContainerViewLayout alloc] init];
    }
    return _containerViewLayout;
}

- (CGSize)itemSize {
    if (CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        _itemSize = self.frame.size;
    }
    return _itemSize;
}

#pragma mark - Setter
- (void)setAutomaticSwitch:(BOOL)automaticSwitch {
    if (_automaticSwitch != automaticSwitch) {
        _automaticSwitch = automaticSwitch;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView != backgroundView) {
        _backgroundView = backgroundView;
        
        [self insertSubview:backgroundView atIndex:0];
        [self setNeedsLayout];
    }
}

@end
