//
//  KKPageContainerViewLayout.m
//  KKPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import "KKPageContainerViewLayout.h"
#import "KKPageView.h"
#import "KKPageTransitionAnimator.h"

@implementation KKPageContainerViewLayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
    KKPageContainerViewLayoutAttributes *copy = [[super copyWithZone:zone] init];
    copy.contentView = _contentView;
    return copy;
}

@end

@interface KKPageContainerViewLayout ()

@property (nonatomic, weak) KKPageView *pageView;

// TODO: [indexPath : KKPageContainerViewLayoutAttributes]
@property (nonatomic, strong) NSMutableDictionary *layoutAttributesMapping;

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, assign) CGFloat unitItemWidth;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat leadingSpacing;

@property (nonatomic, weak, nullable) id<KKPageTransitionAnimator> animator;

@end

@implementation KKPageContainerViewLayout

#pragma mark - 
// TODO: 屏幕旋转

#pragma mark - Override
- (void)prepareLayout {
    [self.layoutAttributesMapping removeAllObjects];
    
    self.itemSize = self.pageView.itemSize;
    self.leadingSpacing = self.pageView.leadingSpacing;
    self.animator = self.pageView.animator;
    
    CGFloat itemSpacing = self.pageView.itemSpacing;
    
    self.numberOfSections = [self.pageView numberOfSectionsInCollectionView:self.collectionView];
    self.numberOfItems = [self.pageView collectionView:self.collectionView numberOfItemsInSection:0];
    self.unitItemWidth = self.itemSize.width + itemSpacing;
    
    self.contentSize = ({
        NSInteger allItemsCount = self.numberOfItems * self.numberOfSections;
        
        // actualItemWidth
        CGFloat actualItemWidth = self.itemSize.width;
        
        // all item width
        CGFloat contentSizeWidth = allItemsCount * actualItemWidth;
        // Leading & trailing spacing
        contentSizeWidth += self.leadingSpacing * 2;
        // all item spacing
        contentSizeWidth += (allItemsCount - 1) * itemSpacing;
        
        CGFloat contentSizeHeight = self.itemSize.height;
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
        KKPageContainerViewLayoutAttributes *transformLayoutAttributes = [self transformLayoutAttributes: (KKPageContainerViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath]];
        [resultingAttributes addObject:transformLayoutAttributes];
    }
    return resultingAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.layoutAttributesMapping[indexPath]) {
        return self.layoutAttributesMapping[indexPath];
    }
    KKPageContainerViewLayoutAttributes *attributes = [KKPageContainerViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect itemFrame = [self itemFrameForIndexPath:indexPath];
    
    attributes.center = CGPointMake(CGRectGetMidX(itemFrame), CGRectGetMidY(itemFrame));
    attributes.size = self.itemSize;
    attributes.contentView = [self.collectionView cellForItemAtIndexPath:indexPath].contentView;
    
    [self.layoutAttributesMapping setObject:attributes forKey:indexPath];
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat proposedContentOffsetX = ({
        
        CGFloat translationX = -[self.collectionView.panGestureRecognizer translationInView:self.collectionView].x;
        CGFloat offset = round(proposedContentOffset.x/self.unitItemWidth) * self.unitItemWidth;
        CGFloat minFlippingDistance = MIN(0.5 * self.unitItemWidth, 150);
        CGFloat originalContentOffsetX = self.collectionView.contentOffset.x - translationX;
        if (fabs(translationX) <= minFlippingDistance) {
            if (fabs(velocity.x) >= 0.3 && fabs(proposedContentOffset.x-originalContentOffsetX) <= self.unitItemWidth*0.5) {
                offset += self.unitItemWidth * (velocity.x) / fabs(velocity.x);
            }
        }
        offset;
    });
    return CGPointMake(proposedContentOffsetX, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Private method
- (NSArray <NSIndexPath *>*)indexPathsOfItemsInRect:(CGRect)rect {

    NSInteger minIndex = MAX((NSInteger)((CGRectGetMinX(rect) - self.leadingSpacing) / self.unitItemWidth), 0);
    NSInteger maxIndex = MIN(ceil((CGRectGetMaxX(rect) - self.leadingSpacing) / self.unitItemWidth), self.numberOfItems * self.numberOfSections);
    
    NSMutableArray *resultingInexPaths = [NSMutableArray array];
    for (NSInteger index = minIndex; index < maxIndex; index++) {
        
        NSInteger item = index % self.numberOfItems;
        NSInteger section = index / self.numberOfItems;
        [resultingInexPaths addObject:[NSIndexPath indexPathForItem:item inSection:section]];
    }
    
    return resultingInexPaths;
}

- (CGPoint)contentOffsetForIndexPath:(NSIndexPath *)indexPath {
    CGPoint origin = [self itemFrameForIndexPath:indexPath].origin;
    
    return CGPointMake(origin.x - self.leadingSpacing, self.collectionView.contentOffset.y);
}

- (CGRect)itemFrameForIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfItems = self.numberOfItems * indexPath.section + indexPath.item;
    CGFloat originX = self.leadingSpacing + indexOfItems * self.unitItemWidth;
    CGFloat originY = (self.collectionView.frame.size.height - self.itemSize.height) / 2;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (KKPageContainerViewLayoutAttributes *)transformLayoutAttributes:(KKPageContainerViewLayoutAttributes *)layoutAttributes {

    CGFloat position = (layoutAttributes.center.x - CGRectGetMidX(self.collectionView.bounds))/self.unitItemWidth;
    layoutAttributes.contentView = [self.collectionView cellForItemAtIndexPath:layoutAttributes.indexPath];
    
    [self.animator transitionAnimationWithLayoutAttributes:layoutAttributes
                                               forPosition:position];
    return layoutAttributes;
}

#pragma mark - Getter
- (NSMutableDictionary *)layoutAttributesMapping {
    if (!_layoutAttributesMapping) {
        _layoutAttributesMapping = [NSMutableDictionary dictionary];
    }
    return _layoutAttributesMapping;
}

- (KKPageView *)pageView {
    if (!_pageView) {
        _pageView = (KKPageView *)[[self.collectionView superview] superview];
    }
    return _pageView;
}

@end
