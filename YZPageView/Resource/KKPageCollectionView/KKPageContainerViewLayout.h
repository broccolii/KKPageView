//
//  KKPageContainerViewLayout.h
//  KKPageView
//
//  Created by Broccoli on 2017/2/16.
//  Copyright © 2017年 broccoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKPageContainerViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIView *contentView;

@end

@interface KKPageContainerViewLayout : UICollectionViewLayout

- (CGPoint)contentOffsetForIndexPath:(NSIndexPath *)indexPath;

@end
