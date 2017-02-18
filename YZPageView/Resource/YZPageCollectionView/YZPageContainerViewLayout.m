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
    YZPageContainerViewLayoutAttributes *copy = [super copyWithZone:zone];
    copy.contentView = _contentView;
    return copy;
}

@end

@interface YZPageContainerViewLayout ()

// indexPath : YZPageContainerViewLayoutAttributes
@property (nonatomic, strong) NSMutableDictionary *layoutAttributesMapping;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, strong) YZPageView *pageView;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation YZPageContainerViewLayout

#pragma mark - 

#pragma mark - Override
- (void)prepareLayout {
    [self.layoutAttributesMapping removeAllObjects];
    
    self.itemSize = self.pageView.itemSize;
//    此方法中计算出全部元素布局所需要的属性并以indexPath为关键字存入字典
//    cell属性的生成方法：
//    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    SupplementaryView属性的生成方法：
//    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"customId" withIndexPath:indexPath];
//    根据indexPath确定attr的frame，或者使用center和size属性来确定frame。
//    把attr保存到字典中
}

- (CGSize)collectionViewContentSize {
//    通过self.collectionView获取相关信息并计算大小
    return CGSizeZero;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    建立一个可变数组attributes
//    遍历所有存储的attr
//    如果frame存在于rect中，则加入数组
//    if(CGRectIntersectsRect(rect, attr.frame)){
//        [attributes addObject:attr]；
//    }
//    返回数组
    return @[];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    只需要返回存储字典里的独立属性即可。
    return nil;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Getter
- (NSInteger)numberOfItems {
    if (!_numberOfItems) {
        _numberOfItems = [_pageView collectionView:self.collectionView numberOfItemsInSection:0];
    }
    return _numberOfItems;
}

-(NSInteger)numberOfSections {
    if (!_numberOfSections) {
        _numberOfSections = [_pageView numberOfSectionsInCollectionView:self.collectionView];
    }
    return _numberOfSections;
}

- (YZPageView *)pageView {
    if (!_pageView) {
        _pageView = (YZPageView *)[self.collectionView superview];
    }
    return _pageView;
}

@end
