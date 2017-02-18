//
//  YZPageContainerViewLayout.m
//  YZPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "YZPageContainerViewLayout.h"
#import "YZPageView.h"

@interface YZPageContainerViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIView *contentView;

@end

@implementation YZPageContainerViewLayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
    YZPageContainerViewLayoutAttributes *copy = [[super copyWithZone:zone] init];
    copy.contentView = _contentView;
    return copy;
}

@end

@interface YZPageContainerViewLayout ()

@property (nonatomic, weak) YZPageView *pageView;

// indexPath : YZPageContainerViewLayoutAttributes
@property (nonatomic, strong) NSMutableDictionary *layoutAttributesMapping;

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, assign) CGFloat unitItemWidth;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) UIEdgeInsets itemEdgeInsert;
@property (nonatomic, assign) CGFloat leadingSpacing;

@end

@implementation YZPageContainerViewLayout

#pragma mark - 

#pragma mark - Override
- (void)prepareLayout {
    [self.layoutAttributesMapping removeAllObjects];
    
    
    self.itemSize = self.pageView.itemSize;
    self.itemSpacing = self.pageView.itemSpacing;
    self.leadingSpacing = self.pageView.leadingSpacing;
    
    self.numberOfItems = [self.pageView collectionView:self.collectionView numberOfItemsInSection:0];
    self.numberOfSections = [self.pageView numberOfSectionsInCollectionView:self.collectionView];
    self.unitItemWidth = self.itemSize.width + self.itemSpacing;
    
    self.contentSize = ({
        NSInteger allItemsCount = self.numberOfItems * self.numberOfSections;
        
        // actualItemWidth
        CGFloat actualItemWidth = self.itemSize.width + self.itemEdgeInsert.left + self.itemEdgeInsert.right;
        
        // all item width
        CGFloat contentSizeWidth = allItemsCount * actualItemWidth;
        // Leading & trailing spacing
        contentSizeWidth += self.leadingSpacing * 2;
        // all item spacing
        contentSizeWidth += (allItemsCount - 1) * self.itemSpacing;
        
        CGFloat contentSizeHeight = self.itemSize.height + self.itemEdgeInsert.top + self.itemEdgeInsert.bottom;
        CGSizeMake(contentSizeWidth, contentSizeHeight);
    });
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *indexPaths = [self indexPathsOfItemsInRect:rect];
    NSMutableArray *resultingAttributes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexPaths) {
        [resultingAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return resultingAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZPageContainerViewLayoutAttributes *attributes = [YZPageContainerViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect itemFrame = [self itemFrameForIndex:indexPath];
    
    attributes.center = CGPointMake(CGRectGetMidX(itemFrame), CGRectGetMidY(itemFrame));
    attributes.size = self.itemSize;
    attributes.contentView = [self.collectionView cellForItemAtIndexPath:indexPath].contentView;
    
    [self.layoutAttributesMapping setObject:attributes forKey:indexPath];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Private method
- (NSArray <NSIndexPath *>*)indexPathsOfItemsInRect:(CGRect)rect {
    // TODO: 测试 0 行的状态 如果没有问题 可以删了这个代码
    if ([self.collectionView numberOfItemsInSection:0] == 0) {
        return [NSArray array];
    }
    
    NSInteger minIndex = MAX((NSInteger)((CGRectGetMinX(rect) - self.leadingSpacing) / self.unitItemWidth), 0);
    NSInteger maxIndex = MIN(ceil((CGRectGetMaxX(rect) - self.leadingSpacing) / self.unitItemWidth), self.numberOfItems * self.numberOfSections);
    
    NSMutableArray *resultingInexPaths = [NSMutableArray array];
    for (NSInteger index = minIndex; index < maxIndex + 1; index++) {
        
        NSInteger item = index % self.numberOfItems;
        NSInteger section = index / self.numberOfItems;
        [resultingInexPaths addObject:[NSIndexPath indexPathForItem:item inSection:section]];
    }
    
    return resultingInexPaths;
}

- (CGRect)itemFrameForIndex:(NSIndexPath *)indexPath {
    NSInteger indexOfItems = self.numberOfItems * indexPath.section + indexPath.item;
    CGFloat originX = self.leadingSpacing + indexOfItems * self.unitItemWidth;
    CGFloat originY = (self.collectionView.frame.size.height - self.itemSize.height) / 2;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

#pragma mark - Getter
- (NSMutableDictionary *)layoutAttributesMapping {
    if (!_layoutAttributesMapping) {
        _layoutAttributesMapping = [NSMutableDictionary dictionary];
    }
    return _layoutAttributesMapping;
}
//- (NSInteger)numberOfItems {
//    if (!_numberOfItems) {
//        _numberOfItems = [self.pageView collectionView:self.collectionView numberOfItemsInSection:0];
//    }
//    return _numberOfItems;
//}
//
//-(NSInteger)numberOfSections {
//    if (!_numberOfSections) {
//        _numberOfSections = [self.pageView numberOfSectionsInCollectionView:self.collectionView];
//    }
//    return _numberOfSections;
//}

- (YZPageView *)pageView {
    if (!_pageView) {
        _pageView = (YZPageView *)[self.collectionView superview];
    }
    return _pageView;
}

@end
